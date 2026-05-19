import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FinanceEntry {
  final String id;
  final DateTime date;
  final String category;
  final double amount;
  final String note;

  const FinanceEntry({
    required this.id,
    required this.date,
    required this.category,
    required this.amount,
    required this.note,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'category': category,
        'amount': amount,
        'note': note,
      };

  factory FinanceEntry.fromJson(Map<dynamic, dynamic> j) => FinanceEntry(
        id: j['id'] as String,
        date: DateTime.parse(j['date'] as String),
        category: j['category'] as String,
        amount: (j['amount'] as num).toDouble(),
        note: (j['note'] as String?) ?? '',
      );
}

final financeBoxProvider = Provider<Box>((ref) => Hive.box('finance'));

final financeListProvider = Provider<List<FinanceEntry>>((ref) {
  final box = ref.watch(financeBoxProvider);
  if (box.isEmpty) {
    final seed = [
      FinanceEntry(
        id: '1',
        date: DateTime.now().subtract(const Duration(days: 1)),
        category: 'Feed',
        amount: -42.50,
        note: 'Layer pellets 50kg',
      ),
      FinanceEntry(
        id: '2',
        date: DateTime.now().subtract(const Duration(days: 3)),
        category: 'Sales',
        amount: 80.00,
        note: 'Eggs to neighbors',
      ),
    ];
    for (final e in seed) {
      box.put(e.id, e.toJson());
    }
  }
  return box.values
      .whereType<Map>()
      .map(FinanceEntry.fromJson)
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date));
});
