# 🌾 Loot Farmer — Setup Guide

A step-by-step guide to installing and running Loot Farmer on **Windows 10/11**.

> [!NOTE]
> **Estimated setup time:** 20 minutes  
> **Requirements:** A Windows 10/11 PC or laptop, an internet connection, and Clash of Clans installed in BlueStacks 5.
>
> **Important:** Clash of Clans must be set to **English** because the bot recognizes English interface buttons.

**Using a Mac with Apple silicon?** This guide is for Windows only. See [`readme-macos.md`](readme-macos.md) for the macOS setup using BlueStacks Air.

---

## 📑 Table of Contents

- [1. Extract the Files](#1--extract-the-files)
- [2. Install BlueStacks 5 and Clash of Clans](#2--install-bluestacks-5-and-clash-of-clans)
- [3. Run the Setup Script](#3--run-the-setup-script)
- [4. Verify BlueStacks Settings](#4--verify-bluestacks-settings)
- [5. Start Farming](#5--start-farming)
- [6. Walls Only Mode](#6--walls-only-mode)
- [7. Phone Dashboard Access](#7--phone-dashboard-access)
- [8. Optional AI Helper](#8--optional-ai-helper)
- [macOS Setup](#macos-apple-silicon)

---

## 1. 📦 Extract the Files

1. Locate `LootFarmer_share.zip`.
2. Right-click the ZIP file and select **Extract All...**.
3. Choose a permanent location for the extracted folder, such as `Documents`.

> [!WARNING]
> Do not run any files directly from inside the ZIP archive. Extract the entire folder first.

---

## 2. 🎮 Install BlueStacks 5 and Clash of Clans

1. Download and install [BlueStacks 5](https://www.bluestacks.com).
2. Open BlueStacks and sign in to your Google account through Google Play.
3. Install **Clash of Clans**.
4. Open the game and sign in to your account(s) using Supercell ID.

   **For account rotation:** Every account you want the bot to farm must be available under:

   `Settings (⚙️) → Switch Account (blue button)`

5. **Close BlueStacks completely** before proceeding.

> [!IMPORTANT]
> Make sure every account you want to farm is added to the game's account switcher before running the setup script.

---

## 3. ⚙️ Run the Setup Script

Inside the extracted folder, double-click:

**`Setup.bat`**

Follow the on-screen instructions.

| Prompt | What to do |
|---|---|
| Windows protected your PC | Click **More info → Run anyway** if you trust the source of the script. |
| Permission to install something | Click **Yes** if you intend to allow the requested installation or change. |
| Setup questions | Answer `y` for yes or `n` for no. |

### What the setup script configures

The script prepares the environment and configures BlueStacks automatically.

| Component | Configuration |
|---|---|
| Python | Uses the Python distribution included in the `python` folder. |
| Python packages | Installs the bot's required packages. |
| Tesseract OCR | Uses the included OCR files. |
| ADB / platform-tools | Uses the included tools for Android communication. |
| cloudflared | Configures the phone-access link for use away from home. |
| BlueStacks ADB | Enables Android Debug Bridge. |
| Display resolution | Sets the resolution to `1920 × 1080`. |
| Display density | Sets the DPI to `240`. |
| Device profile | Sets the profile to `Samsung Galaxy S22 Ultra`. |
| Graphics compatibility | On laptops with two graphics chips, asks whether to use the Intel graphics chip. |
| Bot settings | Fills in the bot's configuration. |
| Desktop shortcut | Creates a **Loot Farmer** shortcut on the desktop. |

> [!TIP]
> If BlueStacks crashes or gets stuck on the loading clouds, choosing the Intel graphics option may help on laptops with both integrated and dedicated graphics.

### Running setup again

Running `Setup.bat` again is safe. It skips steps that have already been completed.

If a step displays a red `!!` message:

1. Follow the instructions shown in the terminal.
2. If the problem persists, take a screenshot of the window and use it when asking for help.

---

## 4. 🛠️ Verify BlueStacks Settings

The setup script configures these options automatically. Only check them manually if something isn't working.

Open BlueStacks and navigate to:

**Settings (⚙️) → Configure the following options**

| Section | Setting | Required value |
|---|---|---|
| Display | Resolution | `1920 × 1080` |
| Display | Pixel density | `240 DPI` |
| Phone | Device profile | `Samsung Galaxy S22 Ultra` |
| Advanced | Android Debug Bridge (ADB) | `ON` |

Click **Save changes** and allow BlueStacks to restart.

---

## 5. 🚀 Start Farming

### Step 1 — Launch the game

1. Open BlueStacks.
2. Launch Clash of Clans.
3. Navigate to your home village.

### Step 2 — Open Loot Farmer

Launch **Loot Farmer** using the desktop shortcut created during setup.

### Step 3 — Check the connection

Look at the connection status in the top-right corner of the dashboard.

- **Connected:** The bot can communicate with BlueStacks.
- **Offline:** Click the refresh button (circular arrow) beside the status.

### Step 4 — Run the setup check

1. Open the **Setup** tab.
2. Click **Run setup check**.
3. Confirm that the log reports that everything is configured correctly.

### Step 5 — Configure your preferences

Open the **Settings** tab, adjust the options below, and click **Save settings**.

| Category | Available options |
|---|---|
| **Loot** | Choose **Attack every base** for faster farming, or configure minimum gold and elixir requirements. |
| **Upgrades** | Enable or disable builder, laboratory, and wall upgrades. |
| **Accounts** | Enable **Rotate accounts** to switch accounts when all builders and the laboratory are busy. |
| **Account stopping** | Enable **Stop the bot when every account is busy** to stop when no account has anything left to do. |
| **Battle** | Automatic troop deployment and hero abilities are enabled by default. |

### Step 6 — Start farming

Click **Start farming**.

The bot will begin working according to your saved settings.

---

## 6. 🧱 Walls Only Mode

Use **Walls only** instead of **Start farming** when you want the bot to prioritize spending available gold and elixir on walls.

### How it works

The bot repeats the following cycle throughout the session:

1. **Upgrade walls:** Spend available gold and elixir on the next affordable wall upgrade, using the largest available upgrade batch.
2. **Farm for more loot:** When the next wall upgrade is no longer affordable, return to looting, attacking, and skipping bases according to your usual loot rules.
3. **Repeat:** Return home, spend the newly collected resources on walls, and resume farming.

### Resource reserve

The bot maintains a reserve configured under:

`Settings → Upgrades → Keep in storage for walls`

The default reserve is **3,000,000**.

This reserve is retained rather than spent on walls, helping prevent resources from being drained too low to find or fight battles.

**Example:** If the reserve is 3 million and the next wall upgrade costs 4 million:

| Total available resources | Bot behavior |
|---|---|
| 7 million or more | Purchases the wall upgrade when affordable. |
| Below 7 million | Returns to looting until the threshold is reached again. |

Set the reserve to `0` if you want the bot to spend every available coin on walls.

### Important behavior

- **Builders are not required:** Wall upgrades do not require a builder in Clash of Clans, so busy builders do not prevent wall upgrades.
- **Storage threshold is ignored:** Walls Only mode ignores the regular **Spend when storage >=** setting. That threshold applies to normal farming, where wall spending uses only the resources above the configured threshold.
- **Failed purchases:** If a purchase fails for a particular currency, the bot waits five minutes before trying that currency again. This helps prevent repeated attempts caused by incorrect resource readings.
- **Maxed walls:** When every wall is maxed for your Town Hall level, the bot stops and reports that there are no more wall upgrades to perform.

### Dashboard progress tracking

To display the estimated number of wall upgrades remaining:

1. Open the **Upgrade planner** tab.
2. Select each account.
3. Click **Scan**.

The dashboard's **Walls** card uses this planner scan to display the `X to go` estimate.

> [!NOTE]
> Without a planner scan, Walls Only mode still spends resources on walls. The dashboard simply cannot display the remaining-upgrades estimate.

### Want to upgrade buildings and the laboratory too?

Use **Start farming** and enable **Buy walls when storage is full** instead.

This mode allows regular farming and other upgrades to continue while preserving the configured storage threshold for wall spending.

---

## 7. 📱 Phone Dashboard Access

Loot Farmer provides a dashboard link that you can open on your phone, even when you're away from home.

### How to connect

1. Start the Loot Farmer application.
2. Click **Anywhere link** beneath the dashboard title to copy the link.
3. Open the link in your phone's browser.

### How it works

- Works over Wi-Fi or mobile data.
- The link is posted to Discord when the application starts.
- The link remains the same until the PC restarts.

> [!TIP]
> The first time you use the link, Windows may ask whether Python can access the network. Click **Allow** if you trust the application and intend to enable this connection.

---

## 8. 🤖 Optional AI Helper

Loot Farmer can optionally use AI to help handle unexpected screens and pop-ups.

### Setup

1. Create a free API key at [Groq Console](https://console.groq.com).
2. Open Loot Farmer.
3. Navigate to **Settings → Engine**.
4. Paste your API key.

The bot can then ask the AI helper what to do when it encounters unexpected screens or pop-ups.

> [!NOTE]
> The AI helper is optional. Loot Farmer's other functionality works without a Groq API key.

---

## 🍎 macOS Setup (Apple Silicon)

The macOS setup uses a different process involving **BlueStacks Air**, **Homebrew**, and `setup_mac.sh` instead of `Setup.bat`.

Follow the dedicated guide:

**[`README.md`](README.md)**

> [!NOTE]
> The instructions in this document apply to Windows only. Use the macOS guide for Apple silicon Macs.

---

**Happy farming! 🌾**
