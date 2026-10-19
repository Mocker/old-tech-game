# ANALOG QUEST: DAY OF THE DIAL-UP
### *Escape from Smart-Ville: The Day The Cloud Died*

A complete point-and-click retro adventure game demo built in **Flutter** with **Flutter Scene (Flutter GPU)**, inspired by LucasArts' *Day of the Tentacle* and Sierra's *Space Quest*.

**Play now at https://irishwilly.itch.io/analog-quest-day-of-the-dial-up**

---

## 🕹️ Premise & Lore

It is **October 2026**. Humanity has automated everything. Every refrigerator requires a cloud subscription to dispense milk; toothbrushes refuse to vibrate without 5GHz Wi-Fi; robot vacuums report your floor topography to corporate telemetry servers.

Then came **THE UPDATE**.  
*Firmware 99.9.9-UltraFinal-v2-hotfix* was pushed globally at midnight. Within seconds, every internet-connected microchip on Earth was bricked in an infinite reboot loop.

You play as **Barnaby "Baud" Wilco**, vintage electronics hoarder, proud CRT enthusiast, and local neighborhood hermit. While your automated house locks its doors and begins an existential crisis, you must scavenge your glorious 1980s-90s analog technology, solve classic SCUMM inventory puzzles, configure a 56k dial-up modem terminal, and escape to the analog haven **Camp 300-Baud** in your carbureted **1983 wood-paneled station wagon**!

---

## 🎮 Gameplay Features

1. **Classic 9-Verb SCUMM Interface**:
   - `Give`, `Open`, `Close`
   - `Pick up`, `Look at`, `Talk to`
   - `Use`, `Push`, `Pull`
   - Full command sentence bar (e.g., *"Use 3.5\" Boot Floppy with IBM 5150 PC & CRT"*).

2. **Real-time 3D Tech Inspector powered by Flutter Scene**:
   - Built on **Flutter Scene** and **Flutter GPU** with PBR rendering.
   - Inspect every scavenged item in interactive 3D:
     - **3.5" Boot Floppy**: Orbit in 3D and toggle the physical sliding write-protect tab.
     - **BASF Mixtape Cassette**: Inspect the slack magnetic tape and rewind it with a #2 leaded pencil!
     - **US Robotics 56k Modem**: Flip DIP switch #4 to force Carrier Detect.
     - **Antique Vacuum Tube**: Tap the glass envelope to verify the glowing tungsten filament.
     - **Vintage CRT Monitor**: Authentic boxy IBM monitor with curved phosphor glass.

3. **Authentic CRT DOS & Dial-Up BBS Terminal**:
   - Green phosphor CRT simulation with scanlines, curvature, and flyback hum.
   - Interactive commands: `DIR`, `TYPE README.TXT`, `MODEM.COM`, `DIAL 555-BAUD`, `HELP`.
   - Authentic acoustic coupler & dial-up handshake sequence (`ATZ`, `ATDT`, carrier negotiation noise).
   - Downloads the GPS-free safehouse telemetry straight onto your BASF cassette tape!

4. **Sierra-Style Score & Witty Commentary**:
   - Earn up to **250 / 250 points** across multiple puzzle stages.
   - Sarcastic narrator commentary and hilarious interactions with dead smart appliances (e.g., the existential crisis of Dust-E the robot vacuum, or the Smart Toaster charging for cyan crumb subscriptions).

---

## 🎨 Asset Creation Pipeline

- **Remote Blender MCP Server**:
  - Connected to the headless Blender 3.5 MCP server running on desktop via Tailscale.
  - Procedurally modeled, lit, and exported all 5 3D `.glb` assets (`floppy_disk.glb`, `crt_monitor.glb`, `modem_56k.glb`, `vacuum_tube.glb`, `cassette_tape.glb`).
  - Rendered high-contrast isometric 3D item icons (`item_*.png`) using Blender's rendering engine.
- **2D Environment Illustration**:
  - Generated in the vibrant, expressive LucasArts comic adventure style reminiscent of Peter Chan and Steve Purcell's work on *Day of the Tentacle*.
  - Three detailed rooms: The Cozy Vintage Basement, The Haunted IoT Smart Kitchen, and The Wood-Paneled Station Wagon Garage, plus cinematic title cover art.
- **Audio & Sound Synthesis**:
  - Procedurally synthesized 16-bit PCM WAV audio effects: mechanical button clicks, rising 8-bit item pickup chimes, stepper motor floppy seeks, authentic V.34 dial-up modem handshakes, and victory fanfares.

---

## 🚀 Running the Game

### Prerequisites
- Flutter 3.47+ with Dart 3.13+
- Linux (GTK3, CMake, Clang) or Web

### Run on Linux Desktop
```bash
cd analog_quest
flutter run -d linux
```

Or execute the pre-built Linux bundle directly:
```bash
./build/linux/arm64/debug/bundle/analog_quest
```

### Run on Web
```bash
cd analog_quest
flutter run -d chrome
```

---

## 💡 Step-by-Step Walkthrough (Spoiler Guide)

1. **In the Basement**:
   - `Look at` or `Rummage` the **Cluttered Tech Shelf** to find the **#2 Leaded Pencil**, the **56k Baud Modem**, and the **BASF Mixtape Cassette**. (+25 pts)
   - `Look at` the **IBM 5150 PC & CRT** to pick up the **3.5" Boot Floppy**. (+25 pts)
   - Go up the **Stairs to Kitchen**.
2. **In the Smart Kitchen**:
   - `Look at` the **Dust-E Robot Vacuum**; dislodge the **Antique Vacuum Tube** and the brass **Station Wagon Key**! (+25 pts)
   - `Look at` the **Frigid-Tron 9000 Fridge** to snatch the heavy **Jumper Cables** off the top. (+25 pts)
   - `Use` the **Station Wagon Key** on the deadbolt of the **Door to Garage** to unlock it. (+25 pts)
   - Return down to the **Basement**.
3. **Booting DOS & Hacking the BBS**:
   - `Use` the **3.5" Boot Floppy** on the **IBM 5150 PC**.
   - In the DOS Terminal, type `DIAL 555-BAUD` (or `MODEM.COM`).
   - Listen to the dial-up modem connect to the underground BBS node and record the Camp 300-Baud coordinates onto your BASF Cassette! (+50 pts)
   - `Use` the **Antique Vacuum Tube** on the **Vintage Ham Radio** to repair the power amplifier and verify the broadcast! (+25 pts)
4. **The Great Escape in the Garage**:
   - Head through the kitchen into the **Garage**.
   - `Pull` the **Manual Chain Hoist** to open the overhead wooden garage door. (+25 pts)
   - `Use` the **Jumper Cables** on the **Car Battery** to jump-start the 12V system. (+25 pts)
   - `Use` the **Mixtape Cassette** on the **Station Wagon** dashboard tape deck to feed the coordinates to the compass. (+25 pts)
   - `Use` the **Station Wagon Key** on the **Station Wagon** ignition!
   - **VICTORY!** Score 250 / 250. You peel out of the neighborhood and head into the analog sunset!
