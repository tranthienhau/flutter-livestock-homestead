import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../providers/finance_repo.dart';

class FinanceScreen extends ConsumerWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(financeListProvider);
    final fmt = NumberFormat.simpleCurrency();
    final total = entries.fold<double>(0, (s, e) => s + e.amount);
    return Scaffold(
      appBar: AppBar(title: const Text('Finance')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Net this month',
                        style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 4),
                    Text(fmt.format(total),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: total >= 0 ? Colors.green : Colors.red,
                        )),
                  ],
                ),
              ),
            ),
          ),
          if (entries.length > 1)
            SizedBox(
              height: 160,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          for (var i = 0; i < entries.length; i++)
                            FlSpot(i.toDouble(), entries[i].amount),
                        ],
                        isCurved: true,
                        color: Colors.indigo,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: entries.length,
              itemBuilder: (_, i) {
                final e = entries[i];
                return ListTile(
                  leading: Icon(e.amount >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                      color: e.amount >= 0 ? Colors.green : Colors.red),
                  title: Text(e.category),
                  subtitle: Text(e.note),
                  trailing: Text(fmt.format(e.amount)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
