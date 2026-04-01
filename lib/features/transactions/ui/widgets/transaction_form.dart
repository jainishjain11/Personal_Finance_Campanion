import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/transaction.dart';
import '../../providers/transaction_provider.dart';
import 'numeric_keypad.dart';
import 'package:intl/intl.dart';
import '../../../../core/providers/currency_formatter.dart';

class TransactionForm extends ConsumerStatefulWidget {
  final Transaction? initialTransaction;

  const TransactionForm({super.key, this.initialTransaction});

  @override
  ConsumerState<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends ConsumerState<TransactionForm> {
  late bool _isExpense;
  late String _amountStr;
  late String _category;
  late DateTime _date;
  late TextEditingController _notesController;

  final List<String> _expenseCategories = [
    'Food', 'Transport', 'Utilities', 'Entertainment', 'Health', 'Shopping', 'Other'
  ];
  final List<String> _incomeCategories = [
    'Salary', 'Freelance', 'Investments', 'Gifts', 'Other'
  ];

  @override
  void initState() {
    super.initState();
    final t = widget.initialTransaction;
    _isExpense = t?.isExpense ?? true;
    _amountStr = t?.amount.toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), '') ?? '';
    if (_amountStr == '0') _amountStr = '';
    _category = t?.category ?? _expenseCategories.first;
    _date = t?.date ?? DateTime.now();
    _notesController = TextEditingController(text: t?.notes ?? '');
  }

  void _onKeyPress(String value) {
    setState(() {
      if (value == '.' && _amountStr.contains('.')) return;
      // Limit to 2 decimal places
      if (_amountStr.contains('.') && _amountStr.split('.')[1].length >= 2) return;
      _amountStr += value;
    });
  }

  void _onBackspace() {
    setState(() {
      if (_amountStr.isNotEmpty) {
        _amountStr = _amountStr.substring(0, _amountStr.length - 1);
      }
    });
  }

  void _submit() {
    if (_amountStr.isEmpty || double.tryParse(_amountStr) == null || double.parse(_amountStr) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    final newTransaction = Transaction(
      id: widget.initialTransaction?.id,
      amount: double.parse(_amountStr),
      isExpense: _isExpense,
      category: _category,
      date: _date,
      notes: _notesController.text,
    );

    if (widget.initialTransaction != null) {
      ref.read(transactionListProvider.notifier).updateTransaction(newTransaction);
    } else {
      ref.read(transactionListProvider.notifier).addTransaction(newTransaction);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final categories = _isExpense ? _expenseCategories : _incomeCategories;
    if (!categories.contains(_category)) {
      _category = categories.first;
    }

    final symbol = ref.watch(currencyFormatterProvider).currencySymbol;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Toggle Income / Expense
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTypeChip('Expense', true),
              const SizedBox(width: 16),
              _buildTypeChip('Income', false),
            ],
          ),
          const SizedBox(height: 24),
          // Amount Display
          Center(
            child: Text(
              _amountStr.isEmpty ? '${symbol}0' : '$symbol$_amountStr',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _isExpense ? Colors.redAccent : Colors.green,
                  ),
            ),
          ),
          const SizedBox(height: 24),
          // Category Selection (Scrollable Chips)
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = cat == _category;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) setState(() => _category = cat);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Date & Notes Row
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: _date,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (d != null) setState(() => _date = d);
                  },
                  icon: const Icon(Icons.calendar_today, size: 18),
                  label: Text(DateFormat('MMM d, yyyy').format(_date)),
                  style: TextButton.styleFrom(
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),
            ],
          ),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              hintText: 'Add a note...',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.notes),
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),
          // Keypad
          Expanded(
            child: NumericKeypad(
              onKeyPress: _onKeyPress,
              onBackspace: _onBackspace,
            ),
          ),
          const SizedBox(height: 16),
          // Submit Button
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: Text(
              widget.initialTransaction == null ? 'Add Transaction' : 'Save Changes',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTypeChip(String label, bool isExpenseToggle) {
    final isSelected = _isExpense == isExpenseToggle;
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpense = isExpenseToggle;
          // default category reset
          _category = _isExpense ? _expenseCategories.first : _incomeCategories.first;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected 
              ? (isExpenseToggle ? Colors.redAccent.withOpacity(0.1) : Colors.green.withOpacity(0.1))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected 
                ? (isExpenseToggle ? Colors.redAccent : Colors.green)
                : Colors.grey.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected 
                ? (isExpenseToggle ? Colors.redAccent : Colors.green)
                : Colors.grey,
          ),
        ),
      ),
    );
  }
}
