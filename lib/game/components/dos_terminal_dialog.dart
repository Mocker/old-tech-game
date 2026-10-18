import 'dart:async';
import 'package:flutter/material.dart';

class DosTerminalDialog extends StatefulWidget {
  final VoidCallback onBbsConnected;
  final bool hasCassette;

  const DosTerminalDialog({
    super.key,
    required this.onBbsConnected,
    required this.hasCassette,
  });

  @override
  State<DosTerminalDialog> createState() => _DosTerminalDialogState();
}

class _DosTerminalDialogState extends State<DosTerminalDialog> {
  final List<String> _history = [
    'ANALOG-DOS Version 6.22 (C) Copyright 1988-1994 Analog Systems Corp.',
    '640K RAM Available. EMS Driver Loaded. 0 Smart-Device Daemons Found.',
    'Drive C: Mounted [ANALOG_OS]',
    '',
    'Type "HELP" or "DIR" for commands.',
    '',
  ];

  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _isConnecting = false;
  bool _bbsConnected = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleCommand(String rawCmd) {
    final cmd = rawCmd.trim().toUpperCase();
    setState(() {
      _history.add('C:\\> $rawCmd');
    });

    if (cmd == 'CLS') {
      setState(() {
        _history.clear();
      });
      _scrollToBottom();
      return;
    }

    if (cmd == 'EXIT' || cmd == 'QUIT') {
      Navigator.of(context).pop();
      return;
    }

    if (cmd == 'HELP') {
      _addLines([
        'SUPPORTED COMMANDS:',
        '  DIR          - List files in current directory',
        '  TYPE <file>  - Display file contents (e.g. TYPE README.TXT)',
        '  MODEM.COM    - Open 56k dialer utility',
        '  DIAL <num>   - Dial phone number (e.g. DIAL 555-BAUD)',
        '  CLS          - Clear terminal screen',
        '  EXIT         - Return to room',
      ]);
      return;
    }

    if (cmd == 'DIR') {
      _addLines([
        ' Volume in drive C is ANALOG_OS',
        ' Directory of C:\\',
        '',
        'COMMAND  COM     54,612  10-18-94   6:22a',
        'README   TXT      1,420  10-18-26  12:00p',
        'MODEM    COM     18,204  05-12-96   2:14p',
        'RADIO    EXE     32,768  08-20-91   4:50p',
        '        4 file(s)         107,004 bytes',
        '        0 dir(s)      1,248,512 bytes free',
      ]);
      return;
    }

    if (cmd == 'TYPE README.TXT' || cmd == 'TYPE README') {
      _addLines([
        '--- README.TXT: EMERGENCY SURVIVAL PROTOCOL ---',
        'If you are reading this, the Smart Cloud has collapsed.',
        'All modern microcontrollers are locked in infinite subscription verification.',
        'Safe Haven coordinates are hosted on the underground analog BBS node.',
        'Dial: 555-BAUD to initiate carrier handshake.',
        'Have a BASF Cassette ready to record the audio frequency telemetry!',
      ]);
      return;
    }

    if (cmd.startsWith('DIAL') || cmd == 'MODEM.COM' || cmd == 'MODEM') {
      _startDialupSequence();
      return;
    }

    _addLines([
      'Bad command or file name. Type HELP for a list of commands.',
    ]);
  }

  void _addLines(List<String> lines) {
    setState(() {
      _history.addAll(lines);
      _history.add('');
    });
    _scrollToBottom();
  }

  void _startDialupSequence() async {
    if (_isConnecting || _bbsConnected) return;
    setState(() {
      _isConnecting = true;
    });

    final steps = [
      'Initializing US Robotics 56k Sportster...',
      'ATZ ... OK',
      'ATDT 555-2283 ... [DIALING]',
      'Ring... Ring...',
      'CARRIER DETECTED: 2100Hz ANSWER TONE!',
      'Negotiating V.34 Protocol... (Screeech-Krrrrk-Bzzzzzt)',
      'CONNECT 56000/ARQ/V90/LAPM',
      '',
      '======================================================',
      '      *** THE ANALOG RESISTANCE SAFE-HAVEN BBS ***',
      '               NODE #01 (SYSOP: HACK-O-MATIC)         ',
      '======================================================',
      'WELCOME, SURVIVOR! The cloud is dead, long live copper!',
      '',
      'DECRYPTING CAMP 300-BAUD COORDINATES...',
      'LAT: 34.2219° N, LON: 118.0641° W (Pine Ridge Safehouse)',
      'ELEVATION: 4,200 FT. DEFENSES: ZERO BLUETOOTH RADIOS.',
    ];

    for (int i = 0; i < steps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 350));
      if (!mounted) return;
      setState(() {
        _history.add(steps[i]);
      });
      _scrollToBottom();
    }

    if (widget.hasCassette) {
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;
      setState(() {
        _history.addAll([
          '',
          '[SUCCESS] Coordinates recorded onto BASF Mixtape Cassette!',
          'Insert cassette into your 1983 Station Wagon stereo to navigate!',
        ]);
        _bbsConnected = true;
        _isConnecting = false;
      });
      widget.onBbsConnected();
      _scrollToBottom();
    } else {
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;
      setState(() {
        _history.addAll([
          '',
          '[WARNING] No cassette tape detected in drive!',
          'Find your Mixtape Cassette in the house to record these coordinates!',
        ]);
        _isConnecting = false;
      });
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        width: 800,
        height: 520,
        decoration: BoxDecoration(
          color: const Color(0xFF031605), // Classic IBM Green Phosphor Screen
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF00FF66), width: 4),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00FF66).withValues(alpha: 0.3),
              blurRadius: 25,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Curved screen overlay scanlines
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.15),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.2),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Main Content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Status Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.desktop_windows, color: Color(0xFF00FF66), size: 20),
                          SizedBox(width: 8),
                          Text(
                            'IBM 5150 PC • 8088 CPU • 640KB RAM • CGA DISPLAY',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              color: Color(0xFF00FF66),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: Color(0xFF00FF66)),
                        tooltip: 'Exit Terminal',
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xFF00AA44), thickness: 1),

                  // History Console
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _history.length,
                      itemBuilder: (ctx, idx) {
                        final line = _history[idx];
                        final isBbs = line.contains('***') || line.contains('LAT:');
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Text(
                            line,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 14,
                              height: 1.25,
                              color: isBbs ? const Color(0xFF55FF88) : const Color(0xFF00FF66),
                              fontWeight: isBbs ? FontWeight.bold : FontWeight.normal,
                              shadows: const [
                                Shadow(color: Color(0xFF00FF66), blurRadius: 4),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Prompt input row
                  if (!_isConnecting)
                    Row(
                      children: [
                        const Text(
                          'C:\\> ',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            color: Color(0xFF00FF66),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(color: Color(0xFF00FF66), blurRadius: 6),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _inputController,
                            focusNode: _focusNode,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              color: Color(0xFF00FF66),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            cursorColor: const Color(0xFF00FF66),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onSubmitted: (val) {
                              _handleCommand(val);
                              _inputController.clear();
                              _focusNode.requestFocus();
                            },
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
