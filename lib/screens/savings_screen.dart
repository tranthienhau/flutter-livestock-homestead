import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});
  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  double _saved = 480;
  final double _target = 1500;

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.simpleCurrency();
    final progress = (_saved / _target).clamp(0.0, 1.0);
    return Scaffold(
      appBar: AppBar(title: const Text('Homestead Savings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Goal: New chicken coop'),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progress, minHeight: 12),
            const SizedBox(height: 8),
            Text('${fmt.format(_saved)} / ${fmt.format(_target)}'),
            const Spacer(),
            FilledButton(
              onPressed: () => setState(() => _saved += 25),
              child: const Text('Add \$25 contribution'),
            ),
          ],
        ),
      ),
    );
  }
}
