import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;
import '../game_models.dart';

class FlutterSceneViewerDialog extends StatefulWidget {
  final InventoryItem item;
  final Function(InventoryItem updatedItem)? onItemUpdated;

  const FlutterSceneViewerDialog({
    super.key,
    required this.item,
    this.onItemUpdated,
  });

  @override
  State<FlutterSceneViewerDialog> createState() => _FlutterSceneViewerDialogState();
}

class _FlutterSceneViewerDialogState extends State<FlutterSceneViewerDialog>
    with SingleTickerProviderStateMixin {
  late InventoryItem _item;
  double _yaw = 0.5;
  double _pitch = 0.3;
  final double _distance = 2.4;
  late AnimationController _autoRotateController;
  bool _autoRotate = true;
  String _interactiveFeedback = '';

  @override
  void initState() {
    super.initState();
    _item = widget.item;
    _autoRotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _autoRotateController.dispose();
    super.dispose();
  }

  void _triggerItemAction(String actionName) {
    setState(() {
      final props = Map<String, dynamic>.from(_item.properties);
      if (_item.id == 'floppy') {
        final current = props['writeProtected'] ?? false;
        props['writeProtected'] = !current;
        _interactiveFeedback = !current
            ? 'SNAP! Write-protect window opened. The floppy is now write-protected.'
            : 'CLICK! Write-protect window closed. Ready for boot sector deployment!';
      } else if (_item.id == 'cassette') {
        props['rewound'] = true;
        _interactiveFeedback =
            'You jam the #2 pencil into the cogged spool and twirl it vigorously. The tape is perfectly taut!';
      } else if (_item.id == 'modem') {
        props['dipSwitch4'] = !(props['dipSwitch4'] ?? false);
        _interactiveFeedback =
            'You flick DIP switch #4. CD (Carrier Detect) is forced HIGH. 56k speed unlocked!';
      } else if (_item.id == 'vacuum_tube') {
        _interactiveFeedback =
            'TINK! You tap the vacuum tube glass with your fingernail. The tungsten filament rings like a crystal bell. Indestructible!';
      } else {
        _interactiveFeedback = 'You examine $actionName. Fully analog, zero cloud tracking.';
      }

      _item = _item.copyWith(properties: props);
    });

    widget.onItemUpdated?.call(_item);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: 860,
        height: 580,
        decoration: BoxDecoration(
          color: const Color(0xFF0F141C),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.cyanAccent, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.cyanAccent.withValues(alpha: 0.2),
              blurRadius: 30,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            // Top Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                color: Color(0xFF161F2E),
                borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.view_in_ar, color: Colors.cyanAccent, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'FLUTTER SCENE 3D INSPECTION: ${_item.name.toUpperCase()}',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white70),
                  ),
                ],
              ),
            ),

            // Content Area: 3D View (Left) + Tech Specs & Actions (Right)
            Expanded(
              child: Row(
                children: [
                  // 3D Viewport
                  Expanded(
                    flex: 3,
                    child: GestureDetector(
                      onPanDown: (_) => setState(() => _autoRotate = false),
                      onPanUpdate: (details) {
                        setState(() {
                          _yaw += details.delta.dx * 0.01;
                          _pitch = (_pitch - details.delta.dy * 0.01).clamp(-1.2, 1.2);
                        });
                      },
                      child: Stack(
                        children: [
                          // 3D Scene View powered by Flutter Scene
                          ClipRRect(
                            child: AnimatedBuilder(
                              animation: _autoRotateController,
                              builder: (context, child) {
                                final currentYaw = _autoRotate
                                    ? _yaw + _autoRotateController.value * 2 * pi
                                    : _yaw;
                                final camX = _distance * cos(currentYaw) * cos(_pitch);
                                final camY = _distance * sin(_pitch);
                                final camZ = _distance * sin(currentYaw) * cos(_pitch);

                                return SceneView.declarative(
                                  cameraBuilder: (elapsed) {
                                    return PerspectiveCamera(
                                      position: vm.Vector3(camX, camY, camZ),
                                      target: vm.Vector3(0, 0, 0),
                                    );
                                  },
                                  loadingBuilder: (ctx, progress) => Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const CircularProgressIndicator(color: Colors.cyanAccent),
                                        const SizedBox(height: 12),
                                        Text(
                                          'Compiling GPU Shaders & Loading 3D Mesh...\n${(progress * 100).toInt()}%',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontFamily: 'monospace',
                                            color: Colors.cyanAccent,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  children: [
                                    if (_item.modelPath != null)
                                      SceneModel(
                                        _item.modelPath!,
                                        placeholder: (ctx) => SceneMesh(
                                          geometry: CuboidGeometry(
                                            vm.Vector3(1, 1, 1),
                                            debugColors: true,
                                          ),
                                          material: UnlitMaterial(),
                                        ),
                                        error: (ctx, err) => SceneMesh(
                                          geometry: CuboidGeometry(
                                            vm.Vector3(1, 1, 1),
                                            debugColors: true,
                                          ),
                                          material: UnlitMaterial(),
                                        ),
                                      )
                                    else
                                      SceneMesh(
                                        geometry: CuboidGeometry(
                                          vm.Vector3(0.9, 0.9, 0.9),
                                          debugColors: true,
                                        ),
                                        material: UnlitMaterial(),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),

                          // Viewport Controls Overlay
                          Positioned(
                            bottom: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.touch_app, size: 14, color: Colors.cyanAccent),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'Drag to Orbit 3D',
                                    style: TextStyle(
                                      fontFamily: 'monospace',
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  InkWell(
                                    onTap: () => setState(() => _autoRotate = !_autoRotate),
                                    child: Row(
                                      children: [
                                        Icon(
                                          _autoRotate ? Icons.pause_circle : Icons.play_circle,
                                          size: 14,
                                          color: Colors.amberAccent,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          _autoRotate ? 'Pause Spin' : 'Auto Spin',
                                          style: const TextStyle(
                                            fontFamily: 'monospace',
                                            color: Colors.amberAccent,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Vertical Divider
                  Container(width: 2, color: const Color(0xFF1E2838)),

                  // Right Panel: Item Specs & Actions
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      color: const Color(0xFF131A24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 2D High-Res Icon from Blender
                          Center(
                            child: Container(
                              width: 100,
                              height: 100,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.3)),
                              ),
                              child: Image.asset(_item.iconPath, fit: BoxFit.contain),
                            ),
                          ),
                          const SizedBox(height: 12),

                          Text(
                            _item.name,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.amberAccent,
                            ),
                          ),
                          const SizedBox(height: 8),

                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _item.description,
                                    style: const TextStyle(
                                      color: Color(0xFFC9D1D9),
                                      fontSize: 12,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 14),

                                  // Technical specs list
                                  _buildSpecTile('FORMAT', _getFormatSpec()),
                                  _buildSpecTile('CLOUD DEPENDENCY', '0.00% (Absolute Zero)'),
                                  _buildSpecTile('FIRMWARE STATUS', 'Immune to Brick Update'),
                                  _buildSpecTile('STATUS', _getStatusSpec()),

                                  if (_interactiveFeedback.isNotEmpty) ...[
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.cyanAccent.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: Colors.cyanAccent),
                                      ),
                                      child: Text(
                                        _interactiveFeedback,
                                        style: const TextStyle(
                                          fontFamily: 'monospace',
                                          color: Colors.cyanAccent,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Contextual Action Buttons
                          if (_item.id == 'floppy')
                            _buildActionButton(
                              'Toggle Write-Protect Tab',
                              Icons.lock_open,
                              () => _triggerItemAction('Floppy Write-Protect Tab'),
                            ),
                          if (_item.id == 'cassette')
                            _buildActionButton(
                              'Insert Pencil & Rewind Tape',
                              Icons.replay,
                              () => _triggerItemAction('Cassette Tape'),
                            ),
                          if (_item.id == 'modem')
                            _buildActionButton(
                              'Flip Carrier Detect DIP Switch',
                              Icons.toggle_on,
                              () => _triggerItemAction('Modem DIP Switch'),
                            ),
                          if (_item.id == 'vacuum_tube')
                            _buildActionButton(
                              'Tap Glass (Check Filament)',
                              Icons.lightbulb_outline,
                              () => _triggerItemAction('Vacuum Tube'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'monospace',
                color: Color(0xFF8B949E),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'monospace',
                color: Color(0xFF58A6FF),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getFormatSpec() {
    switch (_item.id) {
      case 'floppy':
        return '3.5" HD (1.44MB, 80 Tracks, MFM)';
      case 'modem':
        return 'V.90 / K56flex (Hayes AT Command Set)';
      case 'vacuum_tube':
        return 'Octal 8-Pin Glass Envelope Tetrode';
      case 'cassette':
        return 'Type II Chrome / 4.76 cm/s';
      default:
        return 'Pure 1980s Analog Hardware';
    }
  }

  String _getStatusSpec() {
    final props = _item.properties;
    switch (_item.id) {
      case 'floppy':
        return (props['writeProtected'] ?? false) ? 'WRITE-PROTECTED' : 'READY TO WRITE';
      case 'cassette':
        return (props['rewound'] ?? false) ? 'REWOUND TO 000' : 'SLACK TAPE';
      case 'modem':
        return (props['dipSwitch4'] ?? true) ? '56K HIGH SPEED' : '300 BAUD SLOW';
      default:
        return 'OPERATIONAL';
    }
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1F6FEB),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(
          label,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}
