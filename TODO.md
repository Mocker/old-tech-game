# Analog Quest — TODO

Human- and editor-readable task tracker for this repo. Checked items are done;
unchecked items are open. Blender-dependent work is documented here, not done.

## Done (2026-10-18)

- [x] Victory "Play Again" reset now clears the selected inventory item, hover
      highlight, active dialog/timer, and resets the verb to Look at.
      (Before: a stale item selection could linger into the replay.)

## Needs Blender — done 2026-10-18

Asset pipeline: Blender 4.5.3 LTS driven headless (scripts in
`~/workspace/ludum-dare-60/props/`). All rendered/modeled 2026-10-18.

- [x] Dedicated inventory icons + 3D models, wired into `game_data.dart`:
  - `#2 pencil` → `assets/images/item_pencil.png` + `assets/models/pencil.glb`
  - `jumper_cables` → `assets/images/item_jumper_cables.png` +
    `assets/models/jumper_cables.glb`
  - `car_key` → `assets/images/item_car_key.png` +
    `assets/models/car_key.glb`
  - Each also got a humorous 3D-inspector action in
    `flutter_scene_viewer.dart`.
- [x] Rotary phone: `assets/models/rotary_phone.glb` +
      `assets/images/item_rotary_phone.png` (adapted from
      `~/workspace/ludum-dare-60/props/rotary_phone.py`). Not wired to an
      inventory item — candidate for the kitchen `wall_phone` hotspot's
      3D view if that ever gets one.

## Backlog (code, no Blender needed)

- [ ] Add macOS/Windows runners if jam judging needs them (currently
      `linux/` + `web/` only).
- [ ] `flutter_scene` is experimental (pinned at ^0.24.3) — re-verify the
      3D inspector after any `flutter pub upgrade`.
- [ ] Design note from the original pitch: a Sierra-style dead-end gag scene
      was planned but never built.

## Working in this repo

- Toolchain: Flutter 3.47.7 / Dart 3.13.5.
- Verify: `flutter pub get && flutter analyze && flutter test`
- Web build: `flutter build web` (verified working 2026-10-18).
- If the flutter tool refuses to run as root: prefix with `BOT=true`
  (bypasses the superuser check via the CI path).
- This VM has no git push credentials (SSH blocked, no HTTPS token);
  pushes go through the Git Data API helper (`gh-push`).
