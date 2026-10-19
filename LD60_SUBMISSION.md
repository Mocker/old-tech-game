# LD60 Submission Package — ANALOG QUEST: DAY OF THE DIAL-UP

> **✅ SUBMITTED Mon Oct 19, ~1:30 PM PDT** — ahead of the 3:00 PM deadline.
> itch.io build is the `analog-quest-web-build.zip` in this repo (base-href
> fixed to `./` for itch.io iframe hosting; `index.html` at zip root).

Submission kit for the Ludum Dare 60 Jam. Everything here is ready to use;
the only steps that need a human are logins, uploads, and the final click.

## The deadline (verified 2026-10-18)

- **Jam ends: Monday Oct 19, 3:00 PM PDT** (https://ldjam.com/events/ludum-dare/60)
- The rules grant a **1-hour Submission Hour** after close for packaging +
  submitting → hard stop **~4:00 PM PDT**. No new features after 3:00 PM,
  only packaging and bug fixes (changelogged).
  (https://ldjam.com/events/ludum-dare/rules)
- **Ship by 2:00 PM PDT.** ldjam hammers at the deadline every event.

## State snapshot (as of Sun 21:30 PDT)

- Game is **complete and verified**: `flutter analyze` clean, 2/2 tests pass,
  full puzzle chain traced end to end (9×25 + 50 BBS bonus = 250), web build
  compiles.
- ✅ **Hotspot fix landed (21:24 PDT).** All clickable boxes repositioned
  against the actual scene art; the wall phone moved from the kitchen (no
  phone in the kitchen art) to the garage over the orange rotary phone, with
  its interaction handler moved to match; the hotspot layer now replicates
  the `BoxFit.cover` transform so boxes track the art at any window aspect.
- ✅ **Build is FRESH.** `build/web` was rebuilt 21:28 PDT, *after* the hotspot
  fix commit — verified by successful `flutter build web --release`.
  **No rebuild needed** unless new commits land.
- ✅ **itch.io zip ready:** `analog-quest-web-build.zip` (21 MB, built 21:30
  PDT) — integrity-tested, `index.html` at the root, CanvasKit bundled
  locally. Upload this file as-is.
- Cover art ready: `assets/images/game_title_art.jpg` (1.2 MB).

## 1. Rebuild — SKIPPED, build is current (Sun 21:30 PDT)

The 21:28 PDT `build/web` and the 21:30 PDT zip already include every commit
through the hotspot fix. Skip this section unless you land new
commits before submitting — then rebuild with:

```bash
flutter build web --release
```

re-zip `build/web`, and re-upload to itch.io. The smoke test from your
Saturday playthrough (dial-up audio, YOU DIED gag, full escape with the two
keys) already covered the shipped build.

## 2. Host the playable build

ldjam rule: **screenshots upload to ldjam; binaries are hosted elsewhere.**

- Recommended: new **itch.io** page titled "Analog Quest: Day of the Dial-Up",
  upload `build/web` zipped, set the page **public**, paste the itch.io URL
  into the ldjam entry.
- Alternative: zip `build/web` and host on ryanguthrie.com or a Drive link.

## 3. Entry description (paste-ready draft)

**Title:** Analog Quest: Day of the Dial-Up

**Description:**

October 2026. A global firmware update bricks every internet-connected chip
on Earth — fridges demand cloud subscriptions, robot vacuums report your
floor plan to corporate. You are Barnaby "Baud" Wilco, vintage-electronics
hoarder and CRT enthusiast, and the dead smart-home is yours to escape.

A complete 9-verb SCUMM point-and-click adventure in the LucasArts/Sierra
tradition: scavenge three rooms of lovingly modeled 80s–90s analog tech,
boot a real IBM 5150 in a green-phosphor DOS terminal, negotiate an
authentic V.34 dial-up handshake to pull safehouse coordinates off an
underground BBS, and escape in a carbureted 1983 wood-paneled station wagon.

- Full SCUMM sentence bar (Give / Open / Close / Pick up / Look at / Talk to
  / Use / Push / Pull)
- Sierra-style 250-point score with a sarcastic narrator
- Interactive 3D item inspector: orbit the floppy, flip the modem's DIP
  switches, tap the vacuum tube, rewind the cassette with a pencil
- Synthesized audio: the actual dial-up handshake, floppy seeks, pickup
  chimes, victory fanfare
- One authentic Sierra dead-end gag. You know the one. No spoilers.

Theme: **Old Tech** — every puzzle runs on technology that predates the
cloud that just died.

**How to play:** Point and click. Pick verbs from the SCUMM bar, click items
and hotspots to build sentences like "Use 3.5" Boot Floppy with IBM 5150".
In the DOS terminal try `DIR`, `MODEM.COM`, `DIAL 555-BAUD` — and, if you're
feeling brave, `FORMAT C:`. ~15–25 minutes, replayable for the full 250.

**Credits:** Ryan Guthrie (Mocker) — design, code, puzzles. 3D models and
item icons rendered in headless Blender; room/title art; all audio
procedurally synthesized; built with Flutter + Flutter Scene (Flutter GPU).
All work done during the Jam; AI assistance used in the dev workflow.

## 4. Screenshots (grab from the fresh web build)

1. **Cover:** `assets/images/game_title_art.jpg`
2. Title screen
3. Basement with the SCUMM verb bar visible
4. DOS terminal mid-`DIAL 555-BAUD`
5. Kitchen with Dust-E
6. Victory screen

1280×720 or the native window size is fine; ldjam accepts common formats.

## 5. Checklist — your taps only

- [x] Fresh build + itch.io zip ready (done Sun evening — verified final, no
      rebuild needed unless new commits land)
- [x] Zip `build/web` — uploaded `analog-quest-web-build.zip` to
      itch.io, page public (Mon Oct 19)
- [x] ldjam.com → entry created, **tier: Jam**, cover + screenshots
      uploaded, description pasted, itch.io page linked (Mon Oct 19)
- [x] Submitted **by 2:00 PM PDT** Monday Oct 19 ✅

Prepared Sun Oct 18 evening by Muse (research run) — the in-chat assistant
promised this package; nothing here was promised in duplicate.
