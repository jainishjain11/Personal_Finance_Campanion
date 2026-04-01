import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumericKeypad extends StatelessWidget {
  final Function(String) onKeyPress;
  final VoidCallback onBackspace;

  const NumericKeypad({
    super.key,
    required this.onKeyPress,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < 3; i++)
          Expanded(
            child: Row(
              children: [
                for (var j = 1; j <= 3; j++)
                  _buildKey(context, '${i * 3 + j}'),
              ],
            ),
          ),
        Expanded(
          child: Row(
            children: [
              _buildKey(context, '.'),
              _buildKey(context, '0'),
              _buildBackspace(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKey(BuildContext context, String value) {
    return Expanded(
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onKeyPress(value);
        },
        borderRadius: BorderRadius.circular(32),
        child: Center(
          child: Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspace(BuildContext context) {
    return Expanded(
      child: IconButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          onBackspace();
        },
        iconSize: 32,
        icon: const Icon(Icons.backspace_outlined),
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
