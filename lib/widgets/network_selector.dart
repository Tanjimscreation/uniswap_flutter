import 'package:flutter/material.dart';

class NetworkSelector extends StatelessWidget {
  final String selectedNetwork;
  final ValueChanged<String> onNetworkChanged;

  const NetworkSelector({
    Key? key,
    required this.selectedNetwork,
    required this.onNetworkChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final networks = [
      {'name': 'Ethereum', 'value': 'ethereum', 'icon': '⟠'},
      {'name': 'Polygon', 'value': 'polygon', 'icon': '🟣'},
      {'name': 'Arbitrum', 'value': 'arbitrum', 'icon': '🔵'},
      {'name': 'Base', 'value': 'base', 'icon': '⚪'},
    ];

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2D2D2D)),
      ),
      child: Row(
        children: networks.map((network) {
          final value = network['value'] as String;
          final isSelected = selectedNetwork == value;
          
          return Expanded(
            child: GestureDetector(
              onTap: () => onNetworkChanged(value),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFFF007A)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      network['icon'] as String,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      network['name'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF888888),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
