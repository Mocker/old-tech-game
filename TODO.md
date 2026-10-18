# Analog Quest — TODO

Human- and editor-readable task tracker for this repo. Checked items are done;
unchecked items are open. Blender-dependent work is documented here, not done.

## Done (2026-10-18)

- [x] Victory "Play Again" reset now clears the selected inventory item, hover
      highlight, active dialog/timer, and resets the verb to Look at.
      (Before: a stale item selection could linger into the replay.)

## Needs Blender (documented, not done)

Asset pipeline: Blender 4.5.3 LTS driven headless. The MCP server
(`blender-headless-mcp`, tools: `execute_bpy`, `render_image`,
`submit_animation`/`animation_status`) runs on the Legion desktop at
`H:\Apps\BlenderMCP\server.py`, reachable from the dev VM over Tailscale
(`laptop-j031mhvb:8931`, bearer-token auth). Local modeling scripts live in
`~/workspace/ludum-dare-60/props/` (outside this repo).
Item icons are 512x512 transparent PNGs; 3D models are `.glb` in
`assets/models/`.

- [ ] Dedicated inventory icons — three items currently borrow other items'
      icons (visible in the inventory tray), see `lib/game/game_data.dart`:
  - `#2 pencil` → currently shows `item_cassette_tape.png`
  - `jumper_cables` → currently shows `item_crt_monitor.png`
  - `car_key` → currently shows `item_floppy_disk.png`
- [ ] Rotary wall-phone prop: model + export `.glb` (+ icon) for the kitchen
      `wall_phone` hotspot. A PNG-rendered reference model already exists as
      `~/workspace/ludum-dare-60/props/rotary_phone.py` — it needs a GLB
      export pass, not just a still render.
- [ ] Optional: `.glb` models for pencil / jumper cables / car key so every
      inventory item gets the 3D VIEW inspector (currently only
      floppy/modem/vacuum tube/cassette have models).

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
