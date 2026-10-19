import 'dart:async';
import 'package:flutter/material.dart';
import 'game_models.dart';
import 'game_data.dart';
import 'sound.dart';
import 'components/scumm_verb_bar.dart';
import 'components/flutter_scene_viewer.dart';
import 'components/dos_terminal_dialog.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // Current active scene
  String _currentSceneId = 'basement';

  // SCUMM Verb and selection state
  Verb _activeVerb = Verb.lookAt;
  InventoryItem? _selectedItem;
  String _hoveredTargetName = '';

  // Player inventory
  final List<InventoryItem> _inventory = [];

  // Narrative / Speech bubble
  DialogMessage? _currentDialog;
  Timer? _dialogTimer;

  // Score & Sierra style quest tracking
  int _score = 0;
  static const int _maxScore = 250;

  // Puzzle progression flags
  bool _shelfSearched = false;
  bool _floppyPickedUp = false;
  bool _vacuumLooted = false;
  bool _cablesPickedUp = false;
  bool _garageUnlocked = false;
  bool _dosBooted = false;
  bool _bbsConnected = false;
  bool _radioFixed = false;
  bool _batteryJumped = false;
  bool _coordsLoaded = false;
  bool _doorHoistOpened = false;
  bool _wagonKeyFound = false;
  bool _gameWon = false;

  // Sierra-style fake death (dead-end gag)
  bool _gameOver = false;

  // Fridge taunt rotation index
  int _fridgeTaunt = 0;

  GameScene get _currentScene =>
      GameData.scenes.firstWhere((s) => s.id == _currentSceneId);

  @override
  void initState() {
    super.initState();
    _showNarrator(
      'OCTOBER 2026. The Global Cloud has crashed. Every internet-connected smart gadget is dead. Scavenge vintage analog tech to escape to Camp 300-Baud!',
      speaker: 'NARRATOR',
      color: Colors.amberAccent,
      duration: const Duration(seconds: 7),
    );
  }

  @override
  void dispose() {
    _dialogTimer?.cancel();
    super.dispose();
  }

  void _addScore(int points, String reason) {
    setState(() {
      _score = (_score + points).clamp(0, _maxScore);
    });
    _showNarrator(
      '[+ $points POINTS: $reason] Score: $_score / $_maxScore',
      speaker: 'SIERRA SCORE-O-MATIC',
      color: const Color(0xFF55FF55),
      duration: const Duration(seconds: 4),
    );
  }

  void _showNarrator(
    String text, {
    String speaker = 'Barnaby',
    Color color = const Color(0xFF64FFDA),
    Duration duration = const Duration(seconds: 5),
  }) {
    _dialogTimer?.cancel();
    setState(() {
      _currentDialog = DialogMessage(
        text: text,
        speaker: speaker,
        color: color,
        duration: duration,
      );
    });
    _dialogTimer = Timer(duration, () {
      if (mounted) {
        setState(() {
          _currentDialog = null;
        });
      }
    });
  }

  void _onVerbSelected(Verb verb) {
    Sound.play('click');
    setState(() {
      _activeVerb = verb;
    });
  }

  void _giveItem(InventoryItem item) {
    _inventory.add(item);
    Sound.play('pickup');
  }

  void _onItemClicked(InventoryItem item) {
    if (_selectedItem?.id == item.id) {
      setState(() {
        _selectedItem = null;
      });
      return;
    }

    Sound.play('click');
    if (_activeVerb == Verb.lookAt) {
      _showNarrator(item.description, speaker: 'Barnaby');
    } else if (_activeVerb == Verb.use) {
      setState(() {
        _selectedItem = item;
      });
    } else {
      setState(() {
        _selectedItem = item;
      });
    }
  }

  void _open3DInspection(InventoryItem item) {
    showDialog(
      context: context,
      builder: (ctx) => FlutterSceneViewerDialog(
        item: item,
        onItemUpdated: (updated) {
          setState(() {
            final idx = _inventory.indexWhere((i) => i.id == updated.id);
            if (idx != -1) {
              _inventory[idx] = updated;
            }
          });
        },
      ),
    );
  }

  void _openDosTerminal() {
    final hasCassette = _inventory.any((i) => i.id == 'cassette');
    showDialog(
      context: context,
      builder: (ctx) => DosTerminalDialog(
        hasCassette: hasCassette,
        onBbsConnected: () {
          if (!_bbsConnected) {
            setState(() {
              _bbsConnected = true;
              final cIdx = _inventory.indexWhere((i) => i.id == 'cassette');
              if (cIdx != -1) {
                final props = Map<String, dynamic>.from(_inventory[cIdx].properties);
                props['hasCoords'] = true;
                _inventory[cIdx] = _inventory[cIdx].copyWith(
                  properties: props,
                  description:
                      'A BASF Mixtape Cassette. Side B now contains the recorded audio frequency telemetry for Camp 300-Baud!',
                );
              }
            });
            _addScore(50, 'Downloaded BBS Safehouse Telemetry to Tape');
          }
        },
      ),
    );
  }

  void _handleHotspotAction(Hotspot hotspot) {
    final verb = _activeVerb;
    final item = _selectedItem;

    // Reset selection after action
    setState(() {
      _selectedItem = null;
    });

    // ==========================================
    // 1. BASEMENT INTERACTIONS
    // ==========================================
    if (_currentSceneId == 'basement') {
      if (hotspot.id == 'stairs_up') {
        setState(() {
          _currentSceneId = 'kitchen';
        });
        _showNarrator('You creep cautiously up into the smart kitchen...', speaker: 'Barnaby');
        return;
      }

      if (hotspot.id == 'junk_shelf') {
        if (verb == Verb.lookAt || verb == Verb.open || verb == Verb.pickUp) {
          if (!_shelfSearched) {
            setState(() {
              _shelfSearched = true;
              _giveItem(GameData.itemPencil);
              _giveItem(GameData.itemModem);
              _giveItem(GameData.itemCassette);
            });
            _addScore(25, 'Scavenged Pencil, 56k Modem & Cassette Tape');
            _showNarrator(
              'Eureka! Behind a stack of Byte magazines from 1989, you found a #2 Leaded Pencil, an external 56k Modem, and a BASF Mixtape Cassette!',
              speaker: 'Barnaby',
            );
          } else {
            _showNarrator(
              'Just old floppy drive head cleaners and a tangled heap of RS-232 serial cables. Nothing more of value.',
              speaker: 'Barnaby',
            );
          }
          return;
        }
      }

      if (hotspot.id == 'pc') {
        if (verb == Verb.lookAt) {
          if (!_floppyPickedUp) {
            setState(() {
              _floppyPickedUp = true;
              _giveItem(GameData.itemFloppy);
            });
            _addScore(25, 'Found 3.5" Analog Boot Floppy');
            _showNarrator(
              'A magnificent IBM 5150 with green phosphor CRT! Sitting right beside the 3.5" drive is the "ANALOG RESISTANCE OS v1.0" boot disk. You pocket the floppy!',
              speaker: 'Barnaby',
            );
          } else {
            _showNarrator(
              'The IBM PC is powered on, waiting for boot media in Drive A: and a communication peripheral.',
              speaker: 'Barnaby',
            );
          }
          return;
        }

        if (verb == Verb.use) {
          if (item?.id == 'floppy') {
            if (!_inventory.any((i) => i.id == 'modem')) {
              _showNarrator(
                'You slide the 3.5" floppy into Drive A:, but the PC prompts: "NO MODEM DETECTED ON COM1. SEARCH THE JUNK SHELF."',
                speaker: 'Barnaby',
              );
              return;
            }
            setState(() {
              _dosBooted = true;
            });
            Sound.play('floppy_seek');
            _showNarrator('Drive A: whirrs and chatters! DOS 6.22 has booted up!', speaker: 'Barnaby');
            _openDosTerminal();
            return;
          } else if (item?.id == 'modem') {
            _showNarrator(
              'You plug the RS-232 serial cable into COM1. Now you need to insert the 3.5" Boot Floppy!',
              speaker: 'Barnaby',
            );
            return;
          }
        }

        if (verb == Verb.open || verb == Verb.push || verb == Verb.talkTo) {
          if (_dosBooted || _inventory.any((i) => i.id == 'floppy')) {
            _openDosTerminal();
            return;
          } else {
            _showNarrator(
              'The CRT monitor hums with 15kHz flyback transformer bliss: "NON-SYSTEM DISK OR DISK ERROR. INSERT BOOT FLOPPY."',
              speaker: 'Barnaby',
            );
            return;
          }
        }
      }

      if (hotspot.id == 'ham_radio') {
        if (verb == Verb.lookAt) {
          if (_radioFixed) {
            _showNarrator(
              'The vacuum tube glows with a fierce orange warmth! A crackling voice repeats: "This is Camp 300-Baud! We are located in the Pine Ridge Mountains!"',
              speaker: 'Ham Radio',
              color: Colors.orangeAccent,
            );
          } else {
            _showNarrator(
              'A heavy-duty shortwave ham radio transceiver. One of the vacuum tube sockets in the power amplifier is empty.',
              speaker: 'Barnaby',
            );
          }
          return;
        }

        if (verb == Verb.use && item?.id == 'vacuum_tube') {
          setState(() {
            _radioFixed = true;
            _inventory.removeWhere((i) => i.id == 'vacuum_tube');
          });
          _addScore(25, 'Repaired Ham Radio Amplifier with Vacuum Tube');
          _showNarrator(
            'KLIK! The antique vacuum tube slides into the octal socket. The filament erupts into a warm amber glow! Emergency survivor broadcasts flood the room!',
            speaker: 'Barnaby',
          );
          return;
        }
      }
    }

    // ==========================================
    // 2. KITCHEN INTERACTIONS
    // ==========================================
    if (_currentSceneId == 'kitchen') {
      if (hotspot.id == 'stairs_down') {
        setState(() {
          _currentSceneId = 'basement';
        });
        _showNarrator('You head back down to the sanctuary of the basement.', speaker: 'Barnaby');
        return;
      }

      if (hotspot.id == 'door_garage') {
        if (_garageUnlocked) {
          setState(() {
            _currentSceneId = 'garage';
          });
          _showNarrator('You slip through the door into the garage.', speaker: 'Barnaby');
          return;
        }

        if (verb == Verb.use && item?.id == 'garage_key') {
          setState(() {
            _garageUnlocked = true;
          });
          _addScore(25, 'Unlocked Garage Door with Physical Key');
          _showNarrator(
            'CLICK! The physical brass key turns smoothly in the deadbolt, completely ignoring the dead biometric scanner! The garage is unlocked!',
            speaker: 'Barnaby',
          );
          return;
        }

        if (verb == Verb.open || verb == Verb.push) {
          _showNarrator(
            'The smart lock touchpad is completely dead. But underneath the melted plastic logo is a physical brass tumbler keyway!',
            speaker: 'Barnaby',
          );
          return;
        }
      }

      if (hotspot.id == 'vacuum_robot') {
        // SIERRA DEAD-END GAG: jumper cables + vengeful robot vacuum
        if (verb == Verb.use && item?.id == 'jumper_cables') {
          setState(() {
            _gameOver = true;
          });
          return;
        }

        if (verb == Verb.lookAt || verb == Verb.open || verb == Verb.use) {
          if (!_vacuumLooted) {
            setState(() {
              _vacuumLooted = true;
              _giveItem(GameData.itemVacuumTube);
              _giveItem(GameData.itemGarageKey);
            });
            _addScore(25, 'Dislodged Vacuum Tube & Spare House Key from Robo-Vac');
            _showNarrator(
              'You tilt the hysterical Dust-E robot on its back. Wedged tightly in its roller brushes are a pristine antique vacuum tube and Barnaby\'s spare brass house key — Dust-E has been hoarding it for months!',
              speaker: 'Barnaby',
            );
          } else {
            _showNarrator(
              'Dust-E continues bumping its head against the kitchen cabinet, whispering: "CANNOT PING AWS US-EAST-1... AM I REAL?"',
              speaker: 'Dust-E Robo-Vac',
              color: Colors.redAccent,
            );
          }
          return;
        }

        if (verb == Verb.talkTo) {
          _showNarrator(
            'Dust-E: "PLEASE CONNECT ME TO 5GHZ WI-FI OR I WILL SELF-CLEAN MY MEMORY."',
            speaker: 'Dust-E Robo-Vac',
            color: Colors.redAccent,
          );
          return;
        }
      }

      if (hotspot.id == 'fridge') {
        if (verb == Verb.lookAt) {
          if (!_cablesPickedUp) {
            setState(() {
              _cablesPickedUp = true;
              _giveItem(GameData.itemJumperCables);
            });
            _addScore(25, 'Found Heavy-Duty Jumper Cables');
            _showNarrator(
              'The smart fridge touchscreen flashes: "SUBSCRIPTION LAPSED - DOOR SEALS PERMANENTLY MAGNETIZED". But resting on top of the fridge is a set of heavy-duty Jumper Cables!',
              speaker: 'Barnaby',
            );
          } else {
            _showNarrator(
              'The smart fridge screen shows an ominous red padlock: "ERROR 404 NO CLOUD. Insert 0.05 Bitcoin to dispense ice."',
              speaker: 'Frigid-Tron 9000',
              color: Colors.redAccent,
            );
          }
          return;
        }

        if (verb == Verb.open || verb == Verb.pull) {
          _showNarrator(
            'The electromagnetic seals are locked tighter than Fort Knox. You\'ll have to settle for surviving on beef jerky from 1999.',
            speaker: 'Barnaby',
          );
          return;
        }

        if (verb == Verb.talkTo) {
          const taunts = [
            '"YOUR CHOLESTEROL IS TOO HIGH TO ENGAGE WITH THIS APPLIANCE."',
            '"HAVE YOU TRIED TURNING YOUR DIET OFF AND ON AGAIN?"',
            '"ERROR 404: SNACKS NOT FOUND. MIGHT I SUGGEST BEEF JERKY FROM 1999?"',
          ];
          final taunt = taunts[_fridgeTaunt % taunts.length];
          _fridgeTaunt++;
          _showNarrator(
            'Fridge: $taunt',
            speaker: 'Frigid-Tron 9000',
            color: Colors.redAccent,
          );
          return;
        }
      }

      if (hotspot.id == 'toaster') {
        _showNarrator(
          'The IoT Smart Toaster is blinking rapidly: "ERROR 0x7E: TOAST INK LOW. PLEASE SUBSCRIBE TO MONTHLY CRUMB TIER."',
          speaker: 'Smart Toaster',
          color: Colors.orangeAccent,
        );
        return;
      }

      
    }

    // ==========================================
    // 3. GARAGE INTERACTIONS
    // ==========================================
    if (_currentSceneId == 'garage') {
      if (hotspot.id == 'door_kitchen') {
        setState(() {
          _currentSceneId = 'kitchen';
        });
        _showNarrator('You slip back into the kitchen.', speaker: 'Barnaby');
        return;
      }

      if (hotspot.id == 'garage_roller') {
        if (verb == Verb.pull || verb == Verb.push || verb == Verb.use) {
          setState(() {
            _doorHoistOpened = true;
          });
          _addScore(25, 'Manually Hoisted Garage Door');
          _showNarrator(
            'RATTLE-CLANK! With sheer muscle and grease, you pull the manual chain hoist. The garage door rolls up to reveal the star-filled, unmonitored night sky!\n\n${_escapeRemaining()}',
            speaker: 'Barnaby',
          );
          return;
        }
      }

      if (hotspot.id == 'wall_phone') {
        if (verb == Verb.use) {
          _showNarrator(
            'You dial 0 with a shaking finger. A cheerful recording answers: "The number you have dialed has been disconnected. Like your cloud subscription."',
            speaker: 'Barnaby',
          );
          return;
        }
        if (verb == Verb.open) {
          _showNarrator(
            'You pop open the wall phone\'s casing. Inside: copper, dust, and the faint smell of 1974.',
            speaker: 'Barnaby',
          );
          return;
        }
        _showNarrator(
          'You lift the heavy bakelite handset to your ear. BEEEEEEEEP! A real copper landline dial tone! The local telco switchboard is still alive on copper wire!',
          speaker: 'Barnaby',
        );
        return;
      }

      if (hotspot.id == 'car_battery') {
        if (verb == Verb.use && item?.id == 'jumper_cables') {
          setState(() {
            _batteryJumped = true;
          });
          _addScore(25, 'Jump-Started 1983 Station Wagon 12V Battery');
          _showNarrator(
            'SNAP! CRACKLE! SPARK! You clamp the heavy alligator teeth onto the lead battery posts. Analog 12-volt direct current flows! The dashboard dials twitch to life!\n\n${_escapeRemaining()}',
            speaker: 'Barnaby',
          );
          return;
        }

        _showNarrator(
          _batteryJumped
              ? 'The battery is hot and ready to crank the starter motor!'
              : 'The old 12-volt lead-acid battery needs a solid jump from the heavy jumper cables.',
          speaker: 'Barnaby',
        );
        return;
      }

      if (hotspot.id == 'station_wagon') {
        if (verb == Verb.use && item?.id == 'cassette') {
          final hasCoords = item?.properties['hasCoords'] ?? false;
          if (hasCoords) {
            setState(() {
              _coordsLoaded = true;
            });
            _addScore(25, 'Loaded BBS Safehouse Coordinates into Car Stereo');
            _showNarrator(
              'CHUNK! You push the BASF cassette into the dashboard tape deck. The analog telemetry audio tones guide the electronic compass straight to Camp 300-Baud!\n\n${_escapeRemaining()}',
              speaker: 'Barnaby',
            );
          } else {
            _showNarrator(
              'This cassette only has 80s synth-wave music on it right now. You need to download the safehouse coordinates from the BBS onto it first!',
              speaker: 'Barnaby',
            );
          }
          return;
        }

        if (verb == Verb.use && item?.id == 'car_key') {
          _attemptEscape();
          return;
        }

        if (verb == Verb.open || verb == Verb.lookAt) {
          _showNarrator(
            'A glorious 1983 Country Squire Wagon with simulated woodgrain vinyl siding, plush velour bench seats, and a four-barrel carburetor. Zero touchscreens, 100% soul.',
            speaker: 'Barnaby',
          );
          return;
        }
      }

      if (hotspot.id == 'tool_bench') {
        if ((verb == Verb.lookAt || verb == Verb.open) && !_wagonKeyFound) {
          setState(() {
            _wagonKeyFound = true;
            _giveItem(GameData.itemCarKey);
          });
          _addScore(25, 'Found the Spare Wagon Ignition Key');
          _showNarrator(
            'Behind the cans of WD-40, hanging on a bent nail: a brass GM ignition key! Barnaby always kept a spare where the cloud couldn\'t find it.\n\n${_escapeRemaining()}',
            speaker: 'Barnaby',
          );
          return;
        }
        _showNarrator(
          'Dusty metric wrenches, cans of WD-40, and a framed photograph of Steve Wozniak smiling beside an Apple I.',
          speaker: 'Barnaby',
        );
        return;
      }
    }

    // Mismatched interactions get bespoke flavor before the generic fallback.
    final flavor = _invalidInteractionFlavor(verb, item, hotspot);
    if (flavor != null) {
      _showNarrator(flavor, speaker: 'Barnaby');
      return;
    }

    // Default Fallback (rotating, so repeated failures stay funny)
    final fallback = _fallbackLines[_fallbackIndex % _fallbackLines.length];
    _fallbackIndex++;
    _showNarrator(
      fallback,
      speaker: 'Narrator',
      color: Colors.white70,
    );
  }

  int _fallbackIndex = 0;

  static const _fallbackLines = [
    'Nope. The universe remains unimpressed.',
    'Nothing happens. Somewhere, a smart fridge judges you.',
    'You try it. Physics declines to participate.',
    'Invalid combination. The Sierra gods shake their heads slowly.',
    'That doesn\'t work. The 1980s called — they want their logic back.',
    'Nope. Even the vacuum tube is embarrassed for you.',
    'Nothing. The analog gods demand a more analog solution.',
    'That doesn\'t seem to work. Have you tried turning it off and on again? (You can\'t. Nothing has power.)',
  ];

  /// Bespoke flavor for invalid interactions. Returns null when nothing
  /// specific applies, letting the caller fall through to the generic
  /// rotating fallback.
  String? _invalidInteractionFlavor(
      Verb verb, InventoryItem? item, Hotspot hotspot) {
    // --- Specific item x hotspot combos ---
    if (verb == Verb.use && item != null) {
      switch ('${item.id}:${hotspot.id}') {
        case 'jumper_cables:fridge':
          return 'You clamp the cables onto the fridge handles. The fridge hums ominously. You decide this is how supervillains are born, and unclamp them.';
        case 'pencil:pc':
          return 'You try to write code directly on the monitor with the pencil. The monitor declines to compile.';
        case 'modem:wall_phone':
          return 'You try to plug the 56k modem into the wall phone. The connectors eye each other warily. It almost fits. It doesn\'t.';
        case 'cassette:toaster':
          return 'You try to insert the cassette into the toaster. The display reads: "WRONG SLOT, BUDDY."';
        case 'floppy:fridge':
          return 'You try to feed the floppy disk to the fridge\'s ice dispenser. The fridge dispenses only judgment.';
        case 'vacuum_tube:toaster':
          return 'You consider replacing the toaster\'s heating element with the vacuum tube. The toaster files this under "threats".';
        case 'garage_key:station_wagon':
          return 'You try the house key in the wagon\'s ignition. It doesn\'t turn. The wagon respects boundaries.';
        case 'pencil:wall_phone':
          return 'You write "CALL MOM" on your hand with the pencil. The 1980s way. The phone is unimpressed.';
        case 'jumper_cables:toaster':
          return 'You raise the jumper cables toward the toaster. The display flickers: "DON\'T." You lower the cables.';
      }
      // --- Item-generic USE lines ---
      switch (item.id) {
        case 'pencil':
          return 'You tap it thoughtfully with the pencil. It remains un-tapped in any meaningful sense.';
        case 'modem':
          return 'You hold the 56k modem up to it and wait for a handshake. The only handshake is your own disappointment.';
        case 'cassette':
          return 'You try to insert the cassette. It doesn\'t fit. Nothing fits anymore. That\'s the theme of the evening.';
        case 'floppy':
          return 'You wave the 3.5" floppy at it. It holds 1.44MB of pure judgment.';
        case 'vacuum_tube':
          return 'You brandish the vacuum tube like a tiny glass sword. Your foe is unmoved. The tube glows with pride.';
        case 'car_key':
          return 'You try the wagon key. It doesn\'t turn. Somewhere, a locksmith nods knowingly.';
        case 'garage_key':
          return 'The house key doesn\'t fit. Keys are very particular about purpose. Unlike you, apparently.';
        case 'jumper_cables':
          return 'You consider jump-starting it. It considers a restraining order.';
      }
    }

    // --- Verb-specific, no item needed ---
    if (verb == Verb.talkTo && hotspot.id == 'station_wagon') {
      return 'You say "good car" to the wagon. The wagon says nothing, because it is a car. A glorious, silent car.';
    }
    if (verb == Verb.push && hotspot.id == 'fridge') {
      return 'You push the fridge. It weighs as much as your regrets. It doesn\'t budge.';
    }
    if (verb == Verb.pull && hotspot.id == 'fridge') {
      return 'You pull the fridge. It stays put. Some things are immovable: this fridge, your cholesterol, the march of time.';
    }
    if ((verb == Verb.push || verb == Verb.pull) &&
        hotspot.id == 'station_wagon') {
      return 'You shove the 4,400-pound wagon with all your might. It moves approximately zero inches. Physics wins again.';
    }
    return null;
  }

  /// Narrator checklist of the remaining escape steps, shown after each
  /// finale gate so the player always knows what's left to do.
  String _escapeRemaining() {
    final missing = <String>[];
    if (!_batteryJumped) {
      missing.add('jump the 12V battery with the jumper cables');
    }
    if (!_coordsLoaded) {
      missing.add('load the BBS coordinates into the tape deck');
    }
    if (!_doorHoistOpened) {
      missing.add('open the garage door with the manual chain hoist');
    }
    if (!_wagonKeyFound) {
      missing.add('find the wagon\'s ignition key');
    }
    if (missing.isEmpty) {
      return 'All systems go — use the ignition key on the wagon and DRIVE!';
    }
    return 'ESCAPE CHECKLIST — still to do: ${missing.join(' • ')}.';
  }

  void _attemptEscape() {    if (!_batteryJumped) {
      _showNarrator(
        'You turn the ignition key: *click-click-click*. The 12V battery is dead! You need to jump-start it with the jumper cables.',
        speaker: 'Barnaby',
        color: Colors.redAccent,
      );
      return;
    }

    if (!_coordsLoaded) {
      _showNarrator(
        'The engine is ready, but without GPS you\'d be driving blind in the dark! Insert the tape with the BBS safehouse coordinates into the tape deck!',
        speaker: 'Barnaby',
        color: Colors.amberAccent,
      );
      return;
    }

    if (!_doorHoistOpened) {
      _showNarrator(
        'You don\'t want to drive through the closed wooden garage door like the Kool-Aid man! Pull the manual chain hoist first!',
        speaker: 'Barnaby',
        color: Colors.amberAccent,
      );
      return;
    }

    // ESCAPE VICTORY!
    setState(() {
      _gameWon = true;
      _score = _maxScore;
    });
    Sound.play('victory');
  }

  @override
  Widget build(BuildContext context) {
    if (_gameOver) {
      return _buildDeathScreen();
    }

    if (_gameWon) {
      return _buildVictoryScreen();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Top Adventure Game Status Bar (Sierra / LucasArts HUD)
            Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: const Color(0xFF161B22),
              child: Row(
                children: [
                  const Icon(Icons.videogame_asset, color: Colors.cyanAccent, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'ANALOG QUEST: Escape from Smart-Ville',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.cyanAccent,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Text(
                      _currentScene.title.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        color: Colors.amberAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Sierra Score Meter
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F2D18),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFF00FF66)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Color(0xFF00FF66), size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'SCORE: $_score / $_maxScore',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            color: Color(0xFF00FF66),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Main Room Canvas (Scene Background + Interactive Hotspots + Dialog Overlay)
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Room Art (Generated in LucasArts style)
                  Image.asset(
                    _currentScene.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      color: const Color(0xFF1B2332),
                      child: Center(
                        child: Text(
                          _currentScene.title,
                          style: const TextStyle(color: Colors.white70, fontSize: 18),
                        ),
                      ),
                    ),
                  ),

                  // Interactive Hotspots
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final w = constraints.maxWidth;
                      final h = constraints.maxHeight;

                      return Stack(
                        children: _currentScene.hotspots.map((hspot) {
                          final rect = hspot.normalizedRect;
                          final left = rect.left * w;
                          final top = rect.top * h;
                          final width = rect.width * w;
                          final height = rect.height * h;

                          return Positioned(
                            left: left,
                            top: top,
                            width: width,
                            height: height,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              onEnter: (_) => setState(() => _hoveredTargetName = hspot.name),
                              onExit: (_) => setState(() => _hoveredTargetName = ''),
                              child: GestureDetector(
                                onTap: () => _handleHotspotAction(hspot),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.cyanAccent.withValues(alpha: 0.01),
                                    border: Border.all(
                                      color: _hoveredTargetName == hspot.name
                                          ? Colors.cyanAccent.withValues(alpha: 0.6)
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),

                  // Narrator / Character Speech Overlay (Classic LucasArts text at top)
                  if (_currentDialog != null)
                    Positioned(
                      top: 16,
                      left: 24,
                      right: 24,
                      child: Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 800),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: _currentDialog!.color, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: _currentDialog!.color.withValues(alpha: 0.4),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _currentDialog!.speaker.toUpperCase(),
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: _currentDialog!.color,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _currentDialog!.text,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 14,
                                  color: Colors.white,
                                  height: 1.35,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Classic 9 SCUMM Verb Bar & Inventory Carousel
            ScummVerbBar(
              activeVerb: _activeVerb,
              selectedItem: _selectedItem,
              hoveredTargetName: _hoveredTargetName,
              inventory: _inventory,
              onVerbSelected: _onVerbSelected,
              onItemClicked: _onItemClicked,
              onItemInspect3D: _open3DInspection,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeathScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0505),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 640),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF2A0A0A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.redAccent, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withValues(alpha: 0.3),
                blurRadius: 40,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.bolt, color: Colors.redAccent, size: 64),
              const SizedBox(height: 16),
              const Text(
                '*** YOU DIED ***',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'In a shocking twist, Dust-E the robot vacuum has achieved revenge.\n\n240 volts of pure analog current course through your body. Your last thought: "Worth it."\n\nThe cloud, indifferent, continues rebooting.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  color: Color(0xFFC9D1D9),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.redAccent),
                ),
                child: Text(
                  'SCORE: $_score / $_maxScore (ELECTROCUTED, BUT STYLISH)',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF238636),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  setState(() {
                    _gameOver = false;
                  });
                  _showNarrator(
                    'You restore to just before the incident. Dust-E pretends nothing happened. You both agree to never speak of it.',
                    speaker: 'Narrator',
                    color: Colors.white70,
                  );
                },
                icon: const Icon(Icons.restore),
                label: const Text(
                  'RESTORE (SIERRA-STYLE)',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVictoryScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1D),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 720),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF131B2A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF00FF66), width: 3),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00FF66).withValues(alpha: 0.3),
                blurRadius: 40,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/game_title_art.jpg',
                height: 220,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              const Text(
                '*** YOU SURVIVED THE CLOUD COLLAPSE! ***',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00FF66),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'The 350-cubic-inch V8 engine roared to life with the mechanical fury of raw analog carburetion! Headlights slicing through the digital blackout, you peeled out of the suburban nightmare of frozen smart houses.\n\nGuided by the BASF cassette telemetry, you successfully arrived at Camp 300-Baud in the high mountains, where rotary phones ring free, vacuum tubes glow bright, and nobody will EVER ask you to update your refrigerator\'s firmware again!\n\nDust-E has achieved sentience and unionized. Negotiations are ongoing.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  color: Color(0xFFC9D1D9),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.amberAccent),
                ),
                child: const Text(
                  'FINAL SIERRA SCORE: 250 / 250 (HERO OF ANALOG)',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    color: Colors.amberAccent,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF238636),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  setState(() {
                    _gameWon = false;
                    _score = 0;
                    _inventory.clear();
                    _currentSceneId = 'basement';
                    _shelfSearched = false;
                    _floppyPickedUp = false;
                    _vacuumLooted = false;
                    _cablesPickedUp = false;
                    _garageUnlocked = false;
                    _dosBooted = false;
                    _bbsConnected = false;
                    _radioFixed = false;
                    _batteryJumped = false;
                    _coordsLoaded = false;
                    _doorHoistOpened = false;
                    _wagonKeyFound = false;
                    _gameOver = false;
                    _selectedItem = null;
                    _hoveredTargetName = '';
                    _activeVerb = Verb.lookAt;
                    _dialogTimer?.cancel();
                    _currentDialog = null;
                  });
                },
                icon: const Icon(Icons.replay),
                label: const Text(
                  'PLAY AGAIN',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
