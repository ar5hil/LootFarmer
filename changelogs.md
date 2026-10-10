# Changelog

Built from the git history. Versions below are `APP_VERSION` values in `bot.py`
(the version friends' Update button compares against). Some commits only bumped
the version with no other change — those are noted as "version bump only".
Unreleased local work (v33, not yet committed) is at the top. Note: v18 was
branched/forked oddly — the macOS branch briefly carried v17 then jumped to
v19; there was never a released v18 with distinct changes beyond the security
work listed.

## v35 — 2026-10-10

- New Hidden Treasure handling after returning home: the bot taps the chest (`treasure_chest`) 5-7 times at 0.3s gaps, waits 1.5s for the reveal, then clicks the green Continue (`continue_button`) to get back to the home village.
- `back_to_village()` leaves the treasure popup alone (Back-pressing there could skip the reward) so the main-loop handlers open and collect it instead.

## v34 — 2026-10-10

- New setting in Settings > Recovery: **auto_reconnect** (default on) — the bot clicks TRY AGAIN on the "Connection Lost" dialog (up to 3 attempts, 10s apart), then relaunches the game if it won't clear.
- Connection Lost is detected before every other screen state, so the overlay always wins over dimmed buttons behind it.
- Home village Attack! button now matches both skins: regular (`attack_button`) and the seasonal Treasure Hunt variant (`attack_button_treasure_hunt`) — either one counts as HOME everywhere (detect, village check, boat trips, attacking).

## v33 (unreleased) — 2026-10-10

- New setting in Settings > Battle: **Wait after good loot before deploying (s)** (default `1.0`).
- Good loot found in SCOUT now sleeps that long, then calls `attack()` → `deploy()` directly.
- Removed the `wait_for_battle_start` gate (and its `Battle countdown didn't finish within Xs` spam) from the scout-to-deploy path — deploying starts/joins the battle itself.
- Set to `0` to deploy immediately after a good loot read.

## v32 — 2026-10-08 (merge: upstream v31 into macOS support)

- Merge commit: brought 15 upstream commits (v17 → v31: Builder Base modes/upgrades, Elixir Cart, shared account names, boat/keep-awake fixes, dashboard overhaul, deploy speeds, cloudflared tunnel reuse, security key, easier setup) into the macOS-support branch and re-ported the macOS platform layer on top (BlueStacks Air paths, raw-touch, OCR fixes, auto-detected adb/tesseract/emulator paths, `.app`-aware path checks).
- Follow-up fixes on top of the merge:
  - Unrecognised screens: `debug_unknown.png` captured again (once a minute); Okay/Cancel dialogs now get max 3 Back presses before the game restarts instead of Back-spam forever.
  - BlueStacks Air home screen recognition fix.
  - Troop recognition fix (hue-range spell/troop split, hero vs Clan Castle/siege detection) + Builder Base attack controls (drop points `bb_deploy_1..6` + hero, `bb_battle_max_wait` setting).
  - New Builder Base wall focus setting (`bb_walls_enabled`: reserves a Builder, max 1 building upgrade while walls remain).
  - App identity `ar5hil.LootFarmer`, update repo `ar5hil/LootFarmer`, new default Discord webhook.
  - Docs: `groq-rescue-explained.md`, README renamed to macOS guide, new `readme-windows.md` (migrated from `README.txt`, which was removed).

## v31 — 2026-10-07

- Version bump only (no other change in this commit).

## v30 — 2026-10-07 (walls, shared account names, boat, keep-awake, easier setup)

- Boat trips: drag the map to bring the boat toward the middle when it's hidden under the resource bars before tapping.
- Builder planner ranking: your plan first, then key Builder Base buildings, then priciest.
- Bundled-Python packaging for the published zip (copies the interpreter into `LootFarmer/python/`).
- New `debug_upgrade.png` debug attachment.

## v29 — 2026-10-07 (bug fix)

- Shared-name account handling: `ambiguous()` detection when two accounts share an in-game name; scans never filed under an unknown/ambiguous account; player-tag export settles which account it is (`_sc_key` / `_tag_ok`).
- Wall list scan: one `Wall xN` row per level, swipe to load more rows.
- New `debug_export.png` debug attachment.

## v28 — 2026-10-07 (thrower fix)

- Not sure at the moment (version bump only in this commit; presumably a thrower-troop deploy fix).

## v27 — 2026-10-07 (update)

- Builder Base loot tracking hardened: storage read after every battle, drop/spend detection needs 2 consistent reads before resetting the baseline (hand-spending no longer counts as loot).

## v26 — 2026-10-06 (builder base kart fix)

- Elixir Cart found by its own template (`bb_cart`) at any zoom, not just bubbles.
- Hero cards deploy in Builder Base battles (were skipped).
- Session loot/hour tracking (`track_bb`); `bb_loot` mode label shortened to "Builder Base attacks".

## v25 — 2026-10-05 (bb)

- Version bump only (no other change in this commit).

## v24 — 2026-10-05 (bb)

- Builder Base saving logic: plan's saving resource tracked (`_bb_saving`) so the Star Lab doesn't spend what the builders are saving for; `read_storage` gains a `village` parameter.

## v23 — 2026-10-05 (BB UPDATE)

- `bb_upgrades()` extracted: Builder Base builders + Star Lab follow the planner (or upgrade anything with no plan); account only moves on when nothing is saving up and all slots are busy.

## v22 — 2026-10-05 (BB Update)

- `bb_loot` (attack non-stop, claim cart every 10) vs `bb_farm` (planner upgrades + Star Bonus rounds of 10) modes; desktop/Start-menu shortcuts created with icon.

## v21 — 2026-10-05 (Major Overhaul)

- Windows taskbar identity `APP_ID`; player-tag reading from the Settings window; new `bb_loot` / `bb_farm` Builder Base-only modes; Star Bonus popup handled on either village; `deploy()` returns success so the battle flow reacts to it.

## v20 — 2026-10-04 (live view update)

- Phone live view tunnel: prefer TCP 443 (gets through routers/firewalls/VPNs that block QUIC/UDP); local-URL health check.

## v19 — 2026-10-03 (refactor + deploy speeds)

- Centralised platform handling (Windows-focused; dropped several macOS code paths); bundled tool paths.
- `deploy_select_delay` / `deploy_tap_delay` replaced by the `deploy_speed` dropdown (Fastest/Fast/Normal/Slow, Fastest ≈ whole army in ~1s).
- `deployment_check` deploy verification + richer `debug_deploy.png`; OCR/clipboard hardening; `settings_name` recognition; scan/export retry logic; UI font polish; Discord announce retries.

## v17 (macOS branch) — 2026-10-03

Several commits kept `APP_VERSION = 17` (macOS branch work after the v17 Speed release):

- macOS (BlueStacks Air) support: platform layer, raw-touch + OCR fixes, `setup_mac.sh`, docs.
- OCR: keep the line model as a last resort in the fast (non-thorough) path.
- README: v17 dropped the Home Wi-Fi phone link.
- Walls only mode: spend every coin on walls, loot only when the next upgrade is out of reach (`spend_bank` 0-threshold semantics, free-builder gate dropped for walls, rescan backoff).
- Wall reserve: new `wall_reserve` setting (3,000,000 default) so walls can't drain the bank; `debug_unknown.png` kept for stalls.

## v18 — 2026-10-02 (security)

- Update repo moved to `Geo-Col/lf-app`; Discord start-announce retried in the background (gives up after an hour).

## v17 — 2026-10-02 (Speed)

- Performance/speed pass (large `bot.py` rework); deploy-pan setting becomes a dropdown; `loot_rate` + `line_view` runtime keys; `ADVANCED` setting group ("Show advanced settings"); walls accounting (`walls_left`); new `loot` / `walls` bot modes.

## v16 — 2026-10-01 (massive overhaul)

- Big overhaul: `auto_deploy` / `deploy_units` settings removed (stale config dropped on save); account-tag snapping; per-village zoom kept with zoom-out-first pan; planner upgrade-time estimates from wiki data.

## v15 — 2026-09-29 (builder planner)

- Upgrade planner: building category database (`heroes` / `guardians` / `army` / `defences` / `traps` / `resources`), fuzzy OCR name matching, wiki price/level data (`wiki/buildings.json` + icons), config backups (last 7 days).

## v14 — 2026-09-28 (Maybe Crash Fix?)

- Crash recovery: watchdog enabled by default, `gfx_profile` graphics fallback, zoom-tolerant boat search (`find_any_zoom`), emulator-crash detection with resolution reset.

## v13 — 2026-09-28 (bb)

- Builder Base support begins: BB states (`BBHOME` / `BBEND`), boat travel, collect/cart/bonus/clock/boost, `bb_attack` / `bb_deploy`, BB builder/lab counters, per-account `bb_bonus_days`, new BB templates.

## v12 — 2026-09-27 (update)

- Default Discord webhook; emulator path auto-detect; ADB error messages; Groq-supervisor stall handling; red-zone deploy shift (`shift_line`); resolution self-fix (`fix_resolution`).

## v11 — 2026-09-27 (update)

- Troop-bar reading rework: shared digit reader, level-badge check (empty dashed slots rejected), `debug_deploy.png` preview with drop line, retry ring for troops that didn't land (shifted lines).

## v10 — 2026-09-27 (test)

- Not sure at the moment (version bump only in this commit).

## v9 — 2026-09-27 (test)

- Not sure at the moment (version bump only in this commit).

## v8 — 2026-09-27 (super troop fix)

- Red SUPER troops no longer read as spells: troop/spell split by hue range (troop blue ~104, spell purple 115–150, super red ~179).

## v7 — 2026-09-27 (Test123)

- Not sure at the moment (version bump only in this commit).

## v6 — 2026-09-27 (Update button layout)

- Update button moved under the title (was squeezed out of the header row).

## v5 — 2026-09-27 (test123)

- Not sure at the moment (version bump only in this commit).

## v4 — 2026-09-27 (walls)

- Wall upgrades: find Upgrade buttons by icon, trim Upgrade More selection to what you can afford, never mistake Remove Wall; new `wall_upgrade_hammers` template.

## v3 — 2026-09-27

- Line-ending fix: files stored byte-for-byte (`.gitattributes`) so update hash checks match.

## v2 — 2026-09-27 (initial)

- First commit: Loot Farmer with auto-update (`bot.py`, setup scripts, README, button/digit templates, `manifest.json`).
