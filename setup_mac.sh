#!/bin/bash
# Loot Farmer - one-time setup for macOS (Apple silicon, BlueStacks Air).
# Usage:  bash setup_mac.sh            (set everything up / check everything)
#         bash setup_mac.sh --check    (report only, change nothing)
#         bash setup_mac.sh --fix-adb  (turn Android Debug Bridge on: close BlueStacks first)
# Safe to run again: finished steps are skipped.
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HERE"
CHECK=0
[ "${1:-}" = "--check" ] && CHECK=1

BOLD=$'\033[1m'; DIM=$'\033[2m'; RED=$'\033[31m'; GREEN=$'\033[32m'; YELLOW=$'\033[33m'; CYAN=$'\033[36m'; OFF=$'\033[0m'
step() { printf "\n%s== %s%s\n" "$CYAN" "$1" "$OFF"; }
ok()   { printf "   %sOK%s  %s\n" "$GREEN" "$OFF" "$1"; }
todo() { printf "   %s->%s  %s\n" "$YELLOW" "$OFF" "$1"; }
bad()  { printf "   %s!!%s  %s\n" "$RED" "$OFF" "$1"; }

BS_APP="/Applications/BlueStacks.app"
BS_ADB="$BS_APP/Contents/MacOS/hd-adb"
BS_CONF="/Users/Shared/Library/Application Support/BlueStacks/bluestacks.conf"
[ -f "$BS_CONF" ] || BS_CONF="$HOME/Library/Application Support/BlueStacks/bluestacks.conf"

# ---------------------------------------------------------------- --fix-adb
if [ "${1:-}" = "--fix-adb" ]; then
    [ -f "$BS_CONF" ] || { bad "No BlueStacks config at $BS_CONF"; exit 1; }
    if pgrep -f "BlueStacks.app/Contents/MacOS/BlueStacks" >/dev/null; then
        bad "BlueStacks is running. Quit it first (it rewrites $BS_CONF when it exits), then run this again."
        exit 1
    fi
    cp -n "$BS_CONF" "$BS_CONF.lootfarmer-original" 2>/dev/null
    /usr/bin/python3 - "$BS_CONF" <<'EOF'
import re, sys
p = sys.argv[1]
s = open(p, encoding="utf-8").read()
new, n = re.subn(r'bst\.enable_adb_access="[^"]*"', 'bst.enable_adb_access="1"', s)
if not n:
    new, n = re.subn(r'(bst\.enable_adb_access)', r'\1="1"', s)
if n:
    open(p, "w", encoding="utf-8", newline="").write(new)
print("   Android Debug Bridge turned ON" if n else "   bst.enable_adb_access not found in the config")
EOF
    printf "   Now open BlueStacks Air and start Clash of Clans.\n"
    exit 0
fi

printf "%sLoot Farmer setup (macOS)%s\n" "$BOLD" "$OFF"
[ "$CHECK" = 1 ] && printf "%s(check mode: nothing will be changed)%s\n" "$DIM" "$OFF"

# ---------------------------------------------------------------- 1. macOS / chip
step "This Mac"
if [ "$(uname -m)" = "arm64" ]; then
    ok "$(sw_vers -productName) $(sw_vers -productVersion) on Apple silicon ($(uname -m))"
else
    bad "This is an Intel Mac ($(uname -m)). BlueStacks Air needs an Apple-silicon (M1 or newer) Mac."
    bad "Options: run the bot on a Windows PC, or use an Android emulator that supports ADB on Intel Macs."
fi

# ---------------------------------------------------------------- 2. Python
step "Python"
PY=""
for cand in "$(command -v python3)" /Library/Frameworks/Python.framework/Versions/3.12/bin/python3 \
            /Library/Frameworks/Python.framework/Versions/3.11/bin/python3 /opt/homebrew/bin/python3; do
    if [ -n "$cand" ] && [ -x "$cand" ]; then PY="$cand"; break; fi
done
if [ -z "$PY" ]; then
    bad "No python3 found. Install it from https://www.python.org/downloads/ (or: brew install python), then run this again."
else
    ok "$PY ($("$PY" --version 2>&1))"
    if ! "$PY" -c "import tkinter" 2>/dev/null; then
        bad "This python3 has no tkinter (the bot's window needs it). Use the installer from python.org."
    fi
fi

# ---------------------------------------------------------------- 3. Python packages
step "Python packages"
PKGS="opencv-python Pillow numpy sv-ttk pytesseract"
if [ -n "$PY" ]; then
    MISSING=$("$PY" - <<'EOF'
import importlib.util
print(" ".join(p for m, p in {"cv2":"opencv-python","PIL":"Pillow","numpy":"numpy","sv_ttk":"sv-ttk","pytesseract":"pytesseract"}.items() if importlib.util.find_spec(m) is None))
EOF
)
    if [ -z "$MISSING" ]; then ok "already installed"
    elif [ "$CHECK" = 1 ]; then todo "will install: $MISSING"
    else
        todo "installing: $MISSING"
        "$PY" -m pip install --quiet --upgrade $PKGS || bad "pip install failed - check the internet connection"
        "$PY" -m pip install --quiet groq 2>/dev/null && ok "installed (plus groq, for the optional AI helper)" || ok "installed"
    fi
fi

# ---------------------------------------------------------------- 4. Tesseract OCR
step "Tesseract OCR (reads the loot numbers)"
TESS="$(command -v tesseract || true)"
[ -z "$TESS" ] && [ -x /opt/homebrew/bin/tesseract ] && TESS=/opt/homebrew/bin/tesseract
if [ -n "$TESS" ]; then
    ok "$TESS ($("$TESS" --version 2>&1 | head -1))"
elif [ "$CHECK" = 1 ]; then todo "will install with Homebrew"
elif command -v brew >/dev/null; then
    todo "installing (brew install tesseract)…"
    brew install tesseract && TESS="$(command -v tesseract || echo /opt/homebrew/bin/tesseract)"
else
    bad "Install Homebrew (https://brew.sh) then: brew install tesseract"
fi

# ---------------------------------------------------------------- 5. ADB
step "ADB (Android platform-tools)"
ADB=""
[ -x "$BS_ADB" ] && ADB="$BS_ADB"                       # BlueStacks Air's own adb: always version-matched
[ -z "$ADB" ] && ADB="$(command -v adb || true)"
[ -z "$ADB" ] && [ -x /opt/homebrew/bin/adb ] && ADB=/opt/homebrew/bin/adb
if [ -n "$ADB" ]; then
    ok "$ADB"
elif [ "$CHECK" = 1 ]; then
    todo "will install with Homebrew (android-platform-tools)"
elif command -v brew >/dev/null; then
    todo "installing (brew install android-platform-tools)…"
    brew install android-platform-tools && ADB="$(command -v adb || echo /opt/homebrew/bin/adb)"
else
    bad "Install Homebrew (https://brew.sh) then: brew install android-platform-tools"
fi

# ---------------------------------------------------------------- 6. BlueStacks Air
step "BlueStacks Air"
if [ -d "$BS_APP" ]; then
    ok "installed at $BS_APP"
else
    bad "Not installed. Get it from https://www.bluestacks.com/mac, then:"
    todo "open BlueStacks, sign in to Google Play, install Clash of Clans, log in with Supercell ID,"
    todo "and run this setup again. Make sure the game's language is ENGLISH."
fi

# ---------------------------------------------------------------- 7. BlueStacks settings
step "BlueStacks settings (ADB, resolution, phone profile)"
if [ ! -f "$BS_CONF" ]; then
    bad "No BlueStacks config found (looked at $BS_CONF). Open BlueStacks Air once, close it, run this again."
else
    TMPPY="$(mktemp)"
    cat > "$TMPPY" <<'EOF'
import re, sys
s = open(sys.argv[1], encoding="utf-8", errors="replace").read()
one = lambda p, d="": (re.search(p, s).group(1) if re.search(p, s) else d)
print(one(r'bst\.enable_adb_access="([^"]*)"', "0"),
      one(r'bst\.instance\.[^.\n]+\.fb_width="([^"]*)"'),
      one(r'bst\.instance\.[^.\n]+\.fb_height="([^"]*)"'),
      one(r'bst\.instance\.[^.\n]+\.dpi="([^"]*)"'),
      one(r'bst\.instance\.[^.\n]+\.device_profile_code="([^"]*)"'),
      one(r'bst\.instance\.[^.\n]+\.adb_port="([^"]*)"'))
EOF
    read -r ADB_ON W H DPI PROFILE PORT <<<"$("$PY" "$TMPPY" "$BS_CONF")"
    rm -f "$TMPPY"
    # BlueStacks Air stores the panel in portrait and rotates it: landscape 1920x1080 == fb 1080x1920
    if [ "$ADB_ON" = "1" ]; then ok "Android Debug Bridge (ADB) is ON"; else
        bad "ADB is OFF - the bot can't reach the game. Turn it on in BlueStacks: Settings > Advanced >"
        bad "'Android Debug Bridge', or close BlueStacks and run:  bash setup_mac.sh --fix-adb"
    fi
    [ "$PROFILE" = "sttu" ] && ok "device profile: Samsung Galaxy S22 Ultra (sttu)" \
                            || todo "device profile is '$PROFILE' (the bot was tuned on 'sttu' = Galaxy S22 Ultra)"
    if [ "$W" = "1080" ] && [ "$H" = "1920" ]; then ok "display: 1080x1920 portrait = 1920x1080 landscape, DPI $DPI"
    else todo "display is ${W}x${H}, DPI $DPI - the bot needs 1920x1080 landscape (BlueStacks Settings > Display)"; fi
    ok "ADB port $PORT (the bot connects to 127.0.0.1:$PORT)"
fi

# ---------------------------------------------------------------- 8. cloudflared (optional)
step "cloudflared (optional: the 'Anywhere' phone link)"
CF="$(command -v cloudflared || true)"
if [ -n "$CF" ]; then ok "$CF"
elif [ "$CHECK" = 1 ]; then todo "not installed (optional)"
else todo "not installed - only needed for the away-from-home phone link (brew install cloudflared)"; fi

# ---------------------------------------------------------------- 9. Config
step "Bot config (config.json)"
if [ -n "$PY" ] && [ "$CHECK" = 0 ]; then
    LF_ADB="$ADB" LF_TESS="$TESS" LF_BS_APP="$BS_APP" LF_PORT="${PORT:-5555}" "$PY" - <<'EOF'
import json, os
cfg = {}
if os.path.exists("config.json"):
    try: cfg = json.load(open("config.json", encoding="utf-8"))
    except Exception: cfg = {}
cfg.update(adb_path=os.environ.get("LF_ADB") or cfg.get("adb_path", ""),
           tesseract_path=os.environ.get("LF_TESS") or cfg.get("tesseract_path", ""),
           auto_connect_target="127.0.0.1:" + (os.environ.get("LF_PORT") or "5555"),
           device="")
if os.path.isdir(os.environ.get("LF_BS_APP", "")):
    cfg["emulator_exe_path"] = os.environ["LF_BS_APP"]
    cfg["watchdog_enabled"] = True
json.dump(cfg, open("config.json", "w", encoding="utf-8"), indent=2)
print("   paths written: adb=%s tesseract=%s target=%s" % (cfg.get("adb_path"), cfg.get("tesseract_path"),
                                                            cfg.get("auto_connect_target")))
EOF
else
    todo "will fill in the adb / tesseract / BlueStacks paths"
fi

# ---------------------------------------------------------------- 10. Launcher
step "Launcher"
LAUNCH="$HERE/Loot Farmer.command"
if [ "$CHECK" = 1 ]; then todo "will create 'Loot Farmer.command' here and on the Desktop"
elif [ -n "$PY" ]; then
    cat > "$LAUNCH" <<EOF
#!/bin/bash
# Starts Loot Farmer. Close this Terminal window to quit the bot.
cd "$HERE"
exec "$PY" "$HERE/bot.py"
EOF
    chmod +x "$LAUNCH"
    ln -sf "$LAUNCH" "$HOME/Desktop/Loot Farmer.command" 2>/dev/null
    ok "created 'Loot Farmer.command' (double-click it, or the one on your Desktop)"
fi

printf "\n%sDone.%s\n" "$GREEN" "$OFF"
cat <<'EOF'
Next:
  1. Open BlueStacks Air and start Clash of Clans - sit on the home village (game language: English).
  2. Double-click 'Loot Farmer.command' (on your Desktop).
  3. The top right should say "Connected". If it says "Offline", click the refresh (circle arrow) button.
  4. Setup tab > "Run setup check" - the log should say everything required is set up.
  5. Settings tab - choose what you want, then "Save settings", then press "Start farming".

Note: macOS may ask for permission the first time (Terminal / Python wanting to use the network) - allow it.
EOF
