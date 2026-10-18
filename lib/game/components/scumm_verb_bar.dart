import 'package:flutter/material.dart';
import '../game_models.dart';

class ScummVerbBar extends StatelessWidget {
  final Verb activeVerb;
  final InventoryItem? selectedItem;
  final String hoveredTargetName;
  final List<InventoryItem> inventory;
  final Function(Verb) onVerbSelected;
  final Function(InventoryItem) onItemClicked;
  final Function(InventoryItem) onItemInspect3D;

  const ScummVerbBar({
    super.key,
    required this.activeVerb,
    required this.selectedItem,
    required this.hoveredTargetName,
    required this.inventory,
    required this.onVerbSelected,
    required this.onItemClicked,
    required this.onItemInspect3D,
  });

  String _constructSentence() {
    String text = activeVerb.label;
    if (selectedItem != null) {
      text += ' ${selectedItem!.name}';
      if (activeVerb == Verb.use || activeVerb == Verb.give) {
        text += ' with';
      }
    }
    if (hoveredTargetName.isNotEmpty) {
      if (selectedItem != null && (activeVerb == Verb.use || activeVerb == Verb.give)) {
        text += ' $hoveredTargetName';
      } else if (selectedItem == null) {
        text += ' $hoveredTargetName';
      }
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        border: Border(
          top: BorderSide(color: Colors.cyanAccent.withValues(alpha: 0.5), width: 3),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Sentence line
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            color: const Color(0xFF161B22),
            child: Row(
              children: [
                const Icon(Icons.terminal, color: Colors.amberAccent, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _constructSentence(),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF58A6FF),
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                if (selectedItem != null)
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      backgroundColor: Colors.redAccent.withValues(alpha: 0.2),
                    ),
                    onPressed: () => onItemClicked(selectedItem!),
                    icon: const Icon(Icons.close, color: Colors.redAccent, size: 14),
                    label: const Text(
                      'Cancel Item',
                      style: TextStyle(color: Colors.redAccent, fontSize: 11),
                    ),
                  ),
              ],
            ),
          ),

          // Main Bar: Verbs Grid (Left) + Inventory Carousel (Right)
          Expanded(
            child: Row(
              children: [
                // 3x3 Verb Grid
                SizedBox(
                  width: 320,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                      childAspectRatio: 2.5,
                      physics: const NeverScrollableScrollPhysics(),
                      children: Verb.values.map((v) {
                        final isSelected = activeVerb == v && selectedItem == null;
                        return InkWell(
                          onTap: () => onVerbSelected(v),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF388BFD) : const Color(0xFF21262D),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: isSelected ? Colors.white : const Color(0xFF30363D),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              v.label,
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : const Color(0xFF8B949E),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // Vertical Divider
                Container(
                  width: 2,
                  color: const Color(0xFF30363D),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                ),

                // Inventory Tray
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: inventory.isEmpty
                        ? const Center(
                            child: Text(
                              '[ INVENTORY EMPTY ]\nLook around for scavengeable analog tech!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'monospace',
                                color: Color(0xFF484F58),
                                fontSize: 12,
                              ),
                            ),
                          )
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: inventory.length,
                            separatorBuilder: (ctx, i) => const SizedBox(width: 8),
                            itemBuilder: (ctx, i) {
                              final item = inventory[i];
                              final isCurrent = selectedItem?.id == item.id;
                              return Container(
                                width: 110,
                                decoration: BoxDecoration(
                                  color: isCurrent
                                      ? const Color(0xFF1F6FEB).withValues(alpha: 0.3)
                                      : const Color(0xFF161B22),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isCurrent ? Colors.amberAccent : const Color(0xFF30363D),
                                    width: isCurrent ? 2 : 1,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () => onItemClicked(item),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Image.asset(
                                            item.iconPath,
                                            fit: BoxFit.contain,
                                            errorBuilder: (ctx, err, stack) =>
                                                const Icon(Icons.memory, color: Colors.cyanAccent),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Text(
                                        item.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'monospace',
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: isCurrent ? Colors.amberAccent : Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    if (item.modelPath != null)
                                      InkWell(
                                        onTap: () => onItemInspect3D(item),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          margin: const EdgeInsets.only(bottom: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.cyanAccent.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(3),
                                            border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.4)),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.view_in_ar, size: 10, color: Colors.cyanAccent),
                                              SizedBox(width: 3),
                                              Text(
                                                '3D VIEW',
                                                style: TextStyle(
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.cyanAccent,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
