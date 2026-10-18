import 'package:flutter/material.dart';
import 'game/game_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AnalogQuestApp());
}

class AnalogQuestApp extends StatelessWidget {
  const AnalogQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Analog Quest: Day of the Dial-up',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF58A6FF),
          secondary: Color(0xFF00FF66),
          surface: Color(0xFF161B22),
        ),
        fontFamily: 'monospace',
      ),
      home: const TitleScreen(),
    );
  }
}

class TitleScreen extends StatefulWidget {
  const TitleScreen({super.key});

  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _showHowToPlay() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF161B22),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.cyanAccent, width: 2),
        ),
        title: const Row(
          children: [
            Icon(Icons.help_outline, color: Colors.cyanAccent),
            SizedBox(width: 8),
            Text(
              'HOW TO SURVIVE THE CLOUD COLLAPSE',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.cyanAccent,
              ),
            ),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '• CLASSIC 9 SCUMM VERBS:\n'
                '  Click a verb (Give, Open, Close, Pick up, Look at, Talk to, Use, Push, Pull), then click an object in the room or in your inventory.\n\n'
                '• INTERACTIVE 3D TECH INSPECTOR:\n'
                '  Click [3D VIEW] on items in your inventory tray to open the real-time Flutter Scene 3D viewer! Rotate models in 3D, toggle write-protect tabs, rewind cassettes with pencils, and flip modem DIP switches.\n\n'
                '• CRT DOS TERMINAL:\n'
                '  Boot the vintage IBM 5150 PC with the 3.5" boot disk and 56k modem to connect to the underground BBS at 555-BAUD!\n\n'
                '• ESCAPE TO CAMP 300-BAUD:\n'
                '  Scavenge the dead smart house, unlock the garage, jump-start the 1983 wood-paneled station wagon, and drive to safety!',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Color(0xFFC9D1D9),
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF238636),
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('GOT IT'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D14),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Key Art
          Opacity(
            opacity: 0.35,
            child: Image.asset(
              'assets/images/game_title_art.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // CRT Scanline Vignette
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.8),
                ],
              ),
            ),
          ),

          // Title Content
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 820),
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Game Logo Title Card
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.cyanAccent, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyanAccent.withValues(alpha: 0.3),
                          blurRadius: 25,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.flash_on, color: Colors.amberAccent, size: 28),
                            const SizedBox(width: 8),
                            Text(
                              'ANALOG QUEST',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                color: Colors.cyanAccent,
                                letterSpacing: 4.0,
                                shadows: [
                                  Shadow(
                                    color: Colors.cyanAccent.withValues(alpha: 0.8),
                                    blurRadius: 16,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.flash_on, color: Colors.amberAccent, size: 28),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'DAY OF THE DIAL-UP • ESCAPE FROM SMART-VILLE',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.amberAccent,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tagline
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161B22).withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Text(
                      'All internet-connected devices have bricked.\nOnly 1980s-90s vintage analog tech can save humanity.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        color: Color(0xFF8B949E),
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Action Buttons
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF238636),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: const Color(0xFF00FF66)
                                  .withValues(alpha: 0.4 + _pulseController.value * 0.6),
                              width: 2,
                            ),
                          ),
                          elevation: 8,
                          shadowColor: const Color(0xFF00FF66).withValues(alpha: 0.5),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const GameScreen()),
                          );
                        },
                        icon: const Icon(Icons.play_arrow, size: 28),
                        label: const Text(
                          'START ADVENTURE',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.cyanAccent,
                          side: const BorderSide(color: Colors.cyanAccent),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        onPressed: _showHowToPlay,
                        icon: const Icon(Icons.help_outline, size: 18),
                        label: const Text(
                          'HOW TO PLAY',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                  // Credits
                  const Text(
                    'Built with Flutter Scene (Flutter GPU) • 3D Assets Modeled in Blender MCP • 2D Art via Diffusion',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      color: Color(0xFF484F58),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
