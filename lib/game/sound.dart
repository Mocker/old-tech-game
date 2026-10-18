import 'package:audioplayers/audioplayers.dart';

/// Tiny fire-and-forget sound effects helper for Analog Quest.
///
/// All playback is triggered from user gestures (taps / submitted commands),
/// which keeps web audio autoplay policies happy. Failures are swallowed on
/// purpose: a jam game should never crash because a WAV didn't load.
class Sound {
  Sound._();

  static final AudioPlayer _fx = AudioPlayer();
  static final AudioPlayer _dialup = AudioPlayer();

  /// Play a short effect from `assets/audio/{name}.wav`.
  static Future<void> play(String name) async {
    try {
      await _fx.play(AssetSource('audio/$name.wav'));
    } catch (_) {
      // silence is also a sound
    }
  }

  /// Start the dial-up handshake loop for the BBS sequence.
  static Future<void> startDialup() async {
    try {
      await _dialup.play(AssetSource('audio/dialup.wav'));
    } catch (_) {}
  }

  static Future<void> stopDialup() async {
    try {
      await _dialup.stop();
    } catch (_) {}
  }
}
