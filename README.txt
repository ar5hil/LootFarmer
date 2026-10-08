LOOT FARMER - SETUP GUIDE
=========================

You need: a Windows 10/11 PC or laptop, internet, and about 20 minutes.
The game must be in ENGLISH (the bot recognises the English buttons).

On macOS (Apple silicon)? The steps below are Windows only - see readme-macos.md for the Mac setup (BlueStacks Air).


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
  - Python + the bot's packages (already included in the folder's 'python' folder -
    nothing to install)
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

It always keeps a reserve back: "Keep in storage for walls" (Settings > Upgrades,
3,000,000 by default) is never spent on walls, so the bank can't be drained so low that
the bot can't find or fight a battle. With a reserve of 3M and a 4M next upgrade it buys
walls while there is 7M or more and goes looting below that - exactly the "stop at 3M"
moment. Set the reserve to 0 if you really want every last coin spent on walls.

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
Setting the bot up on a Mac is a different process (BlueStacks Air, Homebrew and
setup_mac.sh instead of Setup.bat), so it has its own guide:

    readme-macos.md      (in this folder - open it with any text editor)

Everything above applies to Windows only.
