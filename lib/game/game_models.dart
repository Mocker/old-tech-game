import 'package:flutter/material.dart';

/// The classic 9 LucasArts SCUMM verbs from Day of the Tentacle
enum Verb {
  give,
  open,
  close,
  pickUp,
  lookAt,
  talkTo,
  use,
  push,
  pull;

  String get label {
    switch (this) {
      case Verb.give:
        return 'Give';
      case Verb.open:
        return 'Open';
      case Verb.close:
        return 'Close';
      case Verb.pickUp:
        return 'Pick up';
      case Verb.lookAt:
        return 'Look at';
      case Verb.talkTo:
        return 'Talk to';
      case Verb.use:
        return 'Use';
      case Verb.push:
        return 'Push';
      case Verb.pull:
        return 'Pull';
    }
  }
}

/// An inventory item with 2D icon, 3D model, and humorous properties
class InventoryItem {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  final String? modelPath;
  final Map<String, dynamic> properties;

  const InventoryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    this.modelPath,
    this.properties = const {},
  });

  InventoryItem copyWith({
    String? id,
    String? name,
    String? description,
    String? iconPath,
    String? modelPath,
    Map<String, dynamic>? properties,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      modelPath: modelPath ?? this.modelPath,
      properties: properties ?? Map.from(this.properties),
    );
  }
}

/// A clickable interactive region on a scene background
class Hotspot {
  final String id;
  final String name;
  /// Normalized coordinates: (x, y, width, height) all between 0.0 and 1.0
  final Rect normalizedRect;
  final String? cursorLabel;

  const Hotspot({
    required this.id,
    required this.name,
    required this.normalizedRect,
    this.cursorLabel,
  });
}

/// An adventure game room / location
class GameScene {
  final String id;
  final String title;
  final String subtitle;
  final String imagePath;
  final List<Hotspot> hotspots;
  final String ambientDescription;

  const GameScene({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.hotspots,
    required this.ambientDescription,
  });
}

/// Dialog speech bubble / narrator message
class DialogMessage {
  final String text;
  final String speaker;
  final Color color;
  final Duration duration;

  const DialogMessage({
    required this.text,
    this.speaker = 'Barnaby',
    this.color = const Color(0xFF64FFDA), // Bright Teal
    this.duration = const Duration(seconds: 4),
  });
}
