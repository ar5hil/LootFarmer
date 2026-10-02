LOOT FARMER - SETUP GUIDE
=========================

You need: a Windows 10/11 PC or laptop, internet, and about 20 minutes.
The game must be in ENGLISH (the bot recognises the English buttons).


STEP 1 - Unzip
--------------
Right-click LootFarmer_share.zip > "Extract All..." and put the folder somewhere
you'll keep it (e.g. Documents). Don't run anything from inside the zip.


STEP 2 - Install BlueStacks 5 and Clash of Clans
------------------------------------------------
1. Download BlueStacks 5 from https://www.bluestacks.com and install it.
2. Open BlueStacks, sign in to Google Play, install Clash of Clans.
3. Open Clash of Clans and log in to your account(s) with Supercell ID.
   (For account rotation, every account you want farmed should appear in
   Settings (cog) > blue switch-account button.)
4. CLOSE BlueStacks.


STEP 3 - Run the setup
----------------------
Double-click  Setup.bat  in the folder.
  - If Windows says "Windows protected your PC": click "More info" > "Run anyway".
  - If Windows asks for permission to install something: click "Yes".
  - Answer its questions with y (yes) or n (no).

It installs everything the bot needs and sets BlueStacks up for it:
  - Python + the bot's packages
  (Tesseract OCR and ADB / platform-tools are already included in the folder - nothing to install)
  - cloudflared (the phone link that works away from home)
  - BlueStacks: turns ON Android Debug Bridge (ADB), sets resolution to
    1920 x 1080 with DPI 240, and sets the phone profile to
    Samsung Galaxy S22 Ultra
  - On laptops with two graphics chips it asks whether to run BlueStacks
    on the Intel chip (say yes if BlueStacks ever crashes on the loading clouds)
  - Fills in the bot's settings and puts "Loot Farmer" on your desktop

Running it again is safe - it skips anything already done. If a step shows
a red "!!" message, do what it says (or send a screenshot of the window).


STEP 4 - Check BlueStacks (only if something doesn't work)
-----------------------------------------------------------
Setup does these for you. To check or set them by hand, open BlueStacks >
Settings (gear icon, bottom-right of the side bar):
  - Display:   Resolution 1920 x 1080,  Pixel density 240 DPI
  - Phone:     Device profile  Samsung Galaxy S22 Ultra
  - Advanced:  Android Debug Bridge (ADB)  ON
Click "Save changes" and let BlueStacks restart.


STEP 5 - Start farming
----------------------
1. Open BlueStacks and Clash of Clans, go to your home village.
2. Open "Loot Farmer" from the desktop.
3. The top right should say "Connected". If it says "Offline", click the
   refresh (circle arrow) button next to it.
4. Setup tab > "Run setup check" - the log should say everything is set up.
5. Settings tab - choose what you want, then "Save settings":
     Loot:      "Attack every base" (fast) or set minimum gold/elixir
     Upgrades:  Builders / Lab / Walls on or off
     Accounts:  "Rotate accounts" to move to your next account when all
                builders and the lab are busy; "Stop the bot when every
                account is busy" to stop once there's nothing left to do
     Battle:    auto-deploy and hero abilities are on already
6. Press "Start farming".


WALLS ONLY MODE
---------------
Press "🧱  Walls only" instead of "Start farming" when you want every coin spent on walls
first. All session long it repeats this:

  1. Empty the storages into walls - gold and elixir go on the next wall upgrade (the
     largest batch you can afford at once), again and again, until the next upgrade is
     out of reach.
  2. Only then go looting, attacking and skipping bases by the same loot rules as usual.
  3. Come home with more loot, spend it on walls again, then loot again.

Walls never need a builder in Clash of Clans, so busy builders don't stop it. It ignores
the "Spend when storage >=" setting (that one is for normal farming, where walls use only
the storage above the threshold). If a purchase fails for a currency it waits 5 minutes
before trying that currency again, so a bad reading can't loop. When every wall is max
for your Town Hall it stops and says so.

The dashboard's Walls card wants one planner scan per account (Upgrade planner tab >
Scan) to show the "X to go" estimate - without a scan the bot still spends every coin on
walls, it just can't display what's left.

If you want builders and the lab to keep upgrading as well, use "Start farming" with
"Buy walls when storage is full" instead - that mode keeps the threshold.

PHONE VIEW
----------
Click "Anywhere link" under the title to copy it, then open it on your phone.
It works from anywhere (Wi-Fi or mobile data), is posted to Discord when the
app starts, and stays the same until the PC restarts. Windows may ask to
let Python use the network the first time - click "Allow".


OPTIONAL - AI helper
--------------------
A free Groq API key (console.groq.com) pasted into Settings > Engine lets
the bot ask an AI what to do on unexpected screens/popups. Everything works
without it.

MAC (Apple silicon) - BlueStacks Air
====================================
BlueStacks Air is the Mac version of BlueStacks and the bot works with it. This section
replaces steps 1-4 above; step 5 (start farming) is exactly the same.

You need: an Apple-silicon Mac (M1 or newer), macOS 13+, about 15 minutes, and the game
in ENGLISH. (Intel Macs can't run BlueStacks Air - use a Windows PC.)


M1 - BlueStacks Air + Clash of Clans
------------------------------------
Download it from https://www.bluestacks.com/mac and install it. Open it, sign in to
Google Play, install Clash of Clans and log in to your account(s) with Supercell ID
(every account you want farmed should appear in Settings (cog) > blue switch-account
button).


M2 - Turn ADB on and check the display
--------------------------------------
BlueStacks Air > Settings:
  - Advanced:  Android Debug Bridge (ADB)   ON
  - Display:   Landscape, 1920x1080
  - Phone:     Samsung Galaxy S22 Ultra  (the bot was tuned on this profile)
Then quit BlueStacks. The setup below checks all of this for you.


M3 - Run the setup
------------------
Open Terminal and run:
    cd /path/to/LootFarmer
    bash setup_mac.sh
It installs what is missing with Homebrew (adb, tesseract, cloudflared) plus the bot's
Python packages, checks BlueStacks' settings, fills config.json in with the Mac paths and
puts "Loot Farmer.command" on your Desktop. Running it again is safe - it only reports
what's missing (bash setup_mac.sh --check makes no changes at all).


M4 - Start farming
------------------
1. Open BlueStacks Air and Clash of Clans, and sit on your home village.
2. Double-click "Loot Farmer.command" (in this folder or on the Desktop).
3. The top right should say "Connected". If it says "Offline", click the refresh
   (circle arrow) button next to it.
4. Setup tab > "Run setup check" - the log should say everything required is set up.
5. Settings tab - choose what you want, "Save settings", then "Start farming" (or press
   "🧱  Walls only" to spend everything on walls first - see WALLS ONLY MODE above).


M5 - One-time calibration (do this once)
----------------------------------------
The bot has to know where the loot numbers and your troop row are, so "Start farming"
stays disabled until you either capture them or copy them over.

Easiest: copy config.json from your Windows LootFarmer folder into this one, then run
    bash setup_mac.sh
again. It re-points the paths to this Mac (adb, tesseract, BlueStacks, ADB target) and
leaves everything else alone, so your drop line, text regions, accounts and settings all
come across. The layout is the same 1920x1080 on both, so the pixel positions match
exactly.

Or capture them on the Mac, Setup tab:
  - Text regions:  pick "Available loot - gold" > Capture, then "Available loot - elixir",
                   then "Overall damage %" (drag a box around just the digits)
  - Screen points: "Set troop line" > drag a line along the row where troops should be
                   dropped (start from a scouting screen)
"Start farming" tells you exactly what is still missing if you press it too early.


GOOD TO KNOW ON A MAC
---------------------
- The bot reads the game through ADB screenshots, so the BlueStacks window may sit behind
  other windows - but keep it running, and stop the Mac from sleeping (System Settings >
  Lock Screen > "Prevent automatic sleeping when the display is off"), or attacks stop.
- Before dropping troops the bot zooms the battle view out with a two-finger pinch written
  straight to the emulator's touch device. If the drop line ever looks wrong, re-capture it
  on a scouting screen: Setup tab > Screen points > "Set troop line".
- The button templates were captured on Windows BlueStacks, so on BlueStacks Air "Attack!"
  matches at about 0.73 (the bot's threshold is 0.70). If the bot ever taps the wrong thing
  on an unexpected pop-up, capture that button again on the Mac (Setup tab > pick the button
  > Capture) and then raise "Match confidence" in Settings > Engine, so the real match is
  well clear of the threshold.
- Tesseract on macOS reads clean digits fine; the in-game numbers are read with the bot's
  own digit templates (no Tesseract), which were verified on BlueStacks Air.
- The phone link is the "Anywhere link" under the title (v17 dropped the Home Wi-Fi one): it needs
  cloudflared, which setup installs, and it is posted to your Discord when the app starts.
- Groq and the Discord webhook work exactly as on Windows.
