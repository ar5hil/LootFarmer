# Loot Farmer - macOS Setup Guide (Apple silicon, BlueStacks Air)

> On Windows? This file is Mac only - see [readme-windows.md](readme-windows.md) (steps 1-5) for the Windows setup.
> Step 5 (start farming) works exactly the same on both.

You need: an Apple-silicon Mac (M1 or newer), macOS 13+, internet, about 15 minutes,
and the game in ENGLISH (the bot recognises the English buttons).
Intel Macs can't run BlueStacks Air - use a Windows PC instead.

## Step 1 - Install BlueStacks Air + Clash of Clans

1. Download BlueStacks Air from <https://www.bluestacks.com/mac> and install it.
2. Open it, sign in to Google Play, install Clash of Clans.
3. Open Clash of Clans and log in to your account(s) with Supercell ID.
   (For account rotation, every account you want farmed should appear in
   Settings (cog) > blue switch-account button.)
4. Quit BlueStacks.

## Step 2 - Turn ADB on and check the display

In BlueStacks Air > Settings:

- Advanced: Android Debug Bridge (ADB) **ON**
- Display: Landscape, **1920x1080**
- Phone: **Samsung Galaxy S22 Ultra** (the bot was tuned on this profile)

Then quit BlueStacks again. The setup script below checks all of this for you.

## Step 3 - Run the setup

Open Terminal and run:

```bash
cd /path/to/LootFarmer
bash setup_mac.sh
```

It installs what is missing with Homebrew (`adb`, `tesseract`, `cloudflared`)
plus the bot's Python packages, checks BlueStacks' settings, fills in
`config.json` with the Mac paths (adb, tesseract, BlueStacks, ADB target),
and puts `Loot Farmer.command` on your Desktop.

- Running it again is safe - it only reports what's missing.
- `bash setup_mac.sh --check` reports only, changes nothing.
- `bash setup_mac.sh --fix-adb` turns ADB on (quit BlueStacks first).

## Step 4 - One-time calibration (do this once)

The bot has to know where the loot numbers and your troop row are, so
"Start farming" stays disabled until you either capture them or copy them over.

**Easiest:** copy `config.json` from your Windows LootFarmer folder into this one,
then run `bash setup_mac.sh` again. It re-points the paths to this Mac (adb,
tesseract, BlueStacks, ADB target) and leaves everything else alone, so your drop
line, text regions, accounts and settings all come across. The layout is the same
1920x1080 on both, so the pixel positions match exactly.

**Or capture them on the Mac,** Setup tab:

- Text regions: pick "Available loot - gold" > Capture, then
  "Available loot - elixir", then "Overall damage %" (drag a box around just the digits)
- Screen points: "Set troop line" > drag a line along the row where troops should
  be dropped (start from a scouting screen)

"Start farming" tells you exactly what is still missing if you press it too early.

## Step 5 - Start farming

1. Open BlueStacks Air and Clash of Clans, sit on your home village.
2. Double-click `Loot Farmer.command` (in this folder or on the Desktop).
3. The top right should say "Connected". If it says "Offline", click the refresh
   (circle arrow) button next to it.
4. Setup tab > "Run setup check" - the log should say everything required is set up.
5. Settings tab - choose what you want, "Save settings", then "Start farming"
   (or press "Walls only" to spend everything on walls first - see
   WALLS ONLY MODE in [README.txt](README.txt)).

## Good to know on a Mac

- The bot reads the game through ADB screenshots, so the BlueStacks window may sit
  behind other windows - but keep it running, and stop the Mac from sleeping
  (System Settings > Lock Screen > "Prevent automatic sleeping when the display
  is off"), or attacks stop.
- Before dropping troops the bot zooms the battle view out with a two-finger pinch
  written straight to the emulator's touch device. If the drop line ever looks wrong,
  re-capture it on a scouting screen: Setup tab > Screen points > "Set troop line".
- The button templates were captured on Windows BlueStacks, so on BlueStacks Air
  "Attack!" matches at about 0.73 (the bot's threshold is 0.70). If the bot ever taps
  the wrong thing on an unexpected pop-up, capture that button again on the Mac
  (Setup tab > pick the button > Capture) and then raise "Match confidence" in
  Settings > Engine, so the real match is well clear of the threshold.
- Tesseract on macOS reads clean digits fine; the in-game numbers are read with the
  bot's own digit templates (no Tesseract), which were verified on BlueStacks Air.
- The phone link is the "Anywhere link" under the title: it needs `cloudflared`,
  which setup installs, and it is posted to your Discord when the app starts.
- Groq and the Discord webhook work exactly as on Windows.
