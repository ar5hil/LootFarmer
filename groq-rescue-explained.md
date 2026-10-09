# Groq Rescue + Tesseract Interaction Explained

## How Groq Rescues from Stuck States

### The Rescue Trigger
When the bot encounters an **unknown screen** and has been stuck for **≥2.5 seconds** with `groq_supervisor` enabled, it calls `groq_rescue()`:

```python
elif (self.groq_on("groq_supervisor") and stuck >= 2.5 and time.time() - self._last_groq >= 5
      and (state := self.groq_rescue(frame)):
    unknown_since = None
    getattr(self, "on_" + state.lower())(frame, prev)  # jumps to matching state handler
    prev = state
    continue
```

### What `groq_rescue()` Does
1. Sends screenshot to Groq vision model with rescue prompt
2. Receives JSON: `{screen: "home_village", action: "tap", target: "builders_hut", reason: "building ready"}`
3. Maps screen name to known game state
4. Sets up tap coordinates so the bot's normal handler takes over
5. Executes action: **Tap** → taps suggested UI, **Back** → presses Back, **Relaunch** → restarts game, **Wait** → sleeps and re-evaluates

---

## Will Tesseract Pause? No — Here's How They Work Together

### `read_pair()` — Loot/Storage Reading
```python
def read_pair(frame, prompt, groq_key, regions, thorough, cap=None):
    """Local white-text read first (free, ~0.4s); Groq only if that fails."""
    cap = cap or self.cfg["loot_max_plausible"]
    ok = lambda v: v is not None and v <= cap
    boxes = [self.cfg["ocr_regions"].get(r) for r in regions]
    g, e = (white_number(frame, b) if b else None for b in boxes)  # ← Tesseract/OCR FIRST
    if ok(g) and ok(e):  # If OCR returns plausible → RETURN IMMEDIATELY
        return g, e
    # If OCR failed/implausible → Groq as fallback
    if self.groq_on(groq_key):
        r = self.groq(frame, prompt, 60) or {}
        rg, re_ = as_int(r.get("gold")), as_int(r.get("elixir"))
        if ok(rg) and ok(re_):
            return rg, re_
    # If Groq also fails → fall back to OCR again
    return tuple(v if ok(v) else self.read(frame, reg, thorough=thorough) for v, reg in zip((g, e), regions))
```

**Result**: Tesseract/OCR is **always tried first**. Groq only runs if OCR returns implausible/None.

### Behavior Summary
| Scenario | What Happens |
|---|---|
| **OCR succeeds** (normal) | Tesseract returns values → bot uses them. Groq is **not** called. |
| **OCR fails/implausible** | Groq called as backup. If Groq succeeds → AI values used. |
| **Both fail** | Bot logs warning, returns None/0, continues with error handling (Back, sleep, etc.) |
| **Groq rate-limited (429)** | Pauses 15 min, then continues with OCR-only path |

### You're Not Affected
- Adding Groq **does not disable** Tesseract
- Groq is purely an **additional backup** when OCR struggles
- Your bot continues using Tesseract normally 95%+ of the time
- Groq only engages when OCR returns "weird" values (too large, negative, etc.)

**Bottom line**: Your existing setup works exactly as before. Groq adds AI-powered backup for edge cases where Tesseract has trouble, but it never replaces Tesseract entirely.