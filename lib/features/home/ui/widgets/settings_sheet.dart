import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/providers/currency_provider.dart';
import '../../../transactions/providers/transaction_provider.dart';

class SettingsSheet extends ConsumerWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeStateProvider);
    final currency = ref.watch(currencyStateProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'Settings',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Theme Toggle
            Text('App Theme', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: ThemeMode.system, label: Text('System')),
                ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
              ],
              selected: {themeMode},
              onSelectionChanged: (Set<ThemeMode> newSelection) {
                ref.read(themeStateProvider.notifier).setTheme(newSelection.first);
              },
            ),
            
            const SizedBox(height: 24),
            
            // Currency Dropdown
            Text('Default Currency', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            DropdownMenu<String>(
              initialSelection: currency,
              expandedInsets: EdgeInsets.zero,
              onSelected: (String? value) {
                if (value != null) {
                  ref.read(currencyStateProvider.notifier).setCurrency(value);
                }
              },
              dropdownMenuEntries: const [
                DropdownMenuEntry(value: 'INR', label: 'INR (₹)'),
                DropdownMenuEntry(value: 'USD', label: 'USD (\$)'),
                DropdownMenuEntry(value: 'EUR', label: 'EUR (€)'),
                DropdownMenuEntry(value: 'GBP', label: 'GBP (£)'),
              ],
            ),
            
            const SizedBox(height: 40),
            
            // Demo Data Button
            ElevatedButton.icon(
              onPressed: () {
                ref.read(transactionListProvider.notifier).loadMockData();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Demo environment loaded successfully! 🚀')),
                );
              },
              icon: const Icon(Icons.science),
              label: const Text('Load Demo Data'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                foregroundColor: Theme.of(context).colorScheme.onTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
