import 'package:flutter/material.dart';
import 'game_models.dart';

class GameData {
  // All initial items available in the world
  static const itemPencil = InventoryItem(
    id: 'pencil',
    name: '#2 Leaded Pencil',
    description: 'An ancient analog writing implement, complete with chewed pink eraser. Essential for manual cassette tape rewinding!',
    iconPath: 'assets/images/item_pencil.png',
    modelPath: 'assets/models/pencil.glb',
  );

  static const itemFloppy = InventoryItem(
    id: 'floppy',
    name: '3.5" Boot Floppy',
    description: '1.44 Megabytes of pure unadulterated computing freedom! Label reads: "ANALOG RESISTANCE OS v1.0 - DO NOT LICK".',
    iconPath: 'assets/images/item_floppy_disk.png',
    modelPath: 'assets/models/floppy_disk.glb',
    properties: {'writeProtected': false},
  );

  static const itemModem = InventoryItem(
    id: 'modem',
    name: '56k Baud Modem',
    description: 'A US Robotics Sportster external dial-up modem. Smells like 1996 and screeching phone lines.',
    iconPath: 'assets/images/item_modem_56k.png',
    modelPath: 'assets/models/modem_56k.glb',
    properties: {'dipSwitch4': true},
  );

  static const itemVacuumTube = InventoryItem(
    id: 'vacuum_tube',
    name: 'Antique Vacuum Tube',
    description: 'A 6L6 beam power tetrode glass tube. The warm amber filament inside is immune to EMPs, Wi-Fi outages, and corporate subscription models.',
    iconPath: 'assets/images/item_vacuum_tube.png',
    modelPath: 'assets/models/vacuum_tube.glb',
  );

  static const itemCassette = InventoryItem(
    id: 'cassette',
    name: 'Mixtape Cassette',
    description: 'A BASF chrome cassette tape. Side A has "Synth-Wave Hits \'88"; Side B is reserved for BBS Safehouse Coordinates.',
    iconPath: 'assets/images/item_cassette_tape.png',
    modelPath: 'assets/models/cassette_tape.glb',
    properties: {'rewound': false, 'hasCoords': false},
  );

  static const itemJumperCables = InventoryItem(
    id: 'jumper_cables',
    name: 'Jumper Cables',
    description: 'Heavy gauge copper cables with menacing alligator teeth. 100% analog electricity transfer device.',
    iconPath: 'assets/images/item_jumper_cables.png',
    modelPath: 'assets/models/jumper_cables.glb',
  );

  static const itemCarKey = InventoryItem(
    id: 'car_key',
    name: 'Station Wagon Key',
    description: 'A jagged piece of brass stamped "GM". No RFID chip, no remote start, no subscription required to unlock horsepower.',
    iconPath: 'assets/images/item_car_key.png',
    modelPath: 'assets/models/car_key.glb',
  );

  static const itemGarageKey = InventoryItem(
    id: 'garage_key',
    name: 'Brass House Key',
    description: 'A heavy brass house key on a lucky rabbit\'s-foot keychain. It smells faintly of WD-40 and 1994.',
    iconPath: 'assets/images/item_car_key.png',
    modelPath: 'assets/models/car_key.glb',
  );

  // Scenes
  static final List<GameScene> scenes = [
    // 1. BASEMENT
    const GameScene(
      id: 'basement',
      title: 'The Last Bastion of Baud',
      subtitle: 'Barnaby\'s Underground Analog Sanctuary',
      imagePath: 'assets/images/vintage_basement.jpg',
      ambientDescription: 'Your basement is packed wall-to-wall with vintage CRT screens, floppy disk racks, and vacuum tube radios. Up above, the sounds of your smart house rebooting endlessly can be heard.',
      hotspots: [
        Hotspot(
          id: 'pc',
          name: 'IBM 5150 PC & CRT',
          normalizedRect: Rect.fromLTWH(0.42, 0.40, 0.22, 0.35),
          cursorLabel: 'Examine IBM PC',
        ),
        Hotspot(
          id: 'ham_radio',
          name: 'Vintage Ham Radio',
          normalizedRect: Rect.fromLTWH(0.08, 0.38, 0.28, 0.42),
          cursorLabel: 'Inspect Ham Radio',
        ),
        Hotspot(
          id: 'junk_shelf',
          name: 'Cluttered Tech Shelf',
          normalizedRect: Rect.fromLTWH(0.66, 0.18, 0.26, 0.45),
          cursorLabel: 'Rummage Shelf',
        ),
        Hotspot(
          id: 'stairs_up',
          name: 'Stairs to Kitchen',
          normalizedRect: Rect.fromLTWH(0.80, 0.63, 0.20, 0.32),
          cursorLabel: 'Go up to Kitchen',
        ),
      ],
    ),

    // 2. KITCHEN
    const GameScene(
      id: 'kitchen',
      title: 'The Haunted IoT Wasteland',
      subtitle: 'Where Appliances Go to Die',
      imagePath: 'assets/images/smart_kitchen.jpg',
      ambientDescription: 'The smart kitchen is in total shambles. Every smart device has frozen with red LED error messages. The robot vacuum is having an existential crisis against a baseboard.',
      hotspots: [
        Hotspot(
          id: 'fridge',
          name: 'Frigid-Tron 9000 Smart Fridge',
          normalizedRect: Rect.fromLTWH(0.30, 0.22, 0.30, 0.65),
          cursorLabel: 'Examine Fridge',
        ),
        Hotspot(
          id: 'vacuum_robot',
          name: 'Dust-E Robot Vacuum',
          normalizedRect: Rect.fromLTWH(0.48, 0.72, 0.24, 0.24),
          cursorLabel: 'Look at Vacuum',
        ),
        Hotspot(
          id: 'toaster',
          name: 'Subscription Smart Toaster',
          normalizedRect: Rect.fromLTWH(0.70, 0.42, 0.18, 0.22),
          cursorLabel: 'Inspect Toaster',
        ),
        Hotspot(
          id: 'door_garage',
          name: 'Door to Garage',
          normalizedRect: Rect.fromLTWH(0.90, 0.28, 0.10, 0.65),
          cursorLabel: 'Open Garage Door',
        ),
        Hotspot(
          id: 'stairs_down',
          name: 'Stairs to Basement',
          normalizedRect: Rect.fromLTWH(0.02, 0.85, 0.22, 0.14),
          cursorLabel: 'Go down to Basement',
        ),
      ],
    ),

    // 3. GARAGE
    const GameScene(
      id: 'garage',
      title: 'The Ark of Carburetors',
      subtitle: 'No Microchips, Just American Iron',
      imagePath: 'assets/images/garage_station_wagon.jpg',
      ambientDescription: 'The crown jewel of your analog collection rests here: a 1983 wood-paneled station wagon. No firmware, no over-the-air updates, just pure mechanical horsepower!',
      hotspots: [
        Hotspot(
          id: 'station_wagon',
          name: '1983 Wood-Paneled Wagon',
          normalizedRect: Rect.fromLTWH(0.12, 0.32, 0.62, 0.52),
          cursorLabel: 'Inspect Wagon',
        ),
        Hotspot(
          id: 'wall_phone',
          name: 'Rotary Landline Phone',
          normalizedRect: Rect.fromLTWH(0.64, 0.25, 0.14, 0.28),
          cursorLabel: 'Inspect Landline',
        ),
        Hotspot(
          id: 'car_battery',
          name: 'Car Battery & Hood',
          normalizedRect: Rect.fromLTWH(0.10, 0.50, 0.22, 0.30),
          cursorLabel: 'Check Battery',
        ),
        Hotspot(
          id: 'tool_bench',
          name: 'Pegboard Workbench',
          normalizedRect: Rect.fromLTWH(0.72, 0.28, 0.26, 0.40),
          cursorLabel: 'Search Workbench',
        ),
        Hotspot(
          id: 'door_kitchen',
          name: 'Door to Kitchen',
          normalizedRect: Rect.fromLTWH(0.01, 0.30, 0.12, 0.60),
          cursorLabel: 'Go to Kitchen',
        ),
        Hotspot(
          id: 'garage_roller',
          name: 'Manual Chain Hoist',
          normalizedRect: Rect.fromLTWH(0.78, 0.68, 0.20, 0.30),
          cursorLabel: 'Pull Chain Hoist',
        ),
      ],
    ),
  ];
}
