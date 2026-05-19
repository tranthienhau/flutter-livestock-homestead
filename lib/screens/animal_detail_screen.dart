import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/animals_repo.dart';

class AnimalDetailScreen extends ConsumerWidget {
  final String id;
  const AnimalDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(animalsRepoProvider);
    final a = repo.byId(id);
    if (a == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Not found')),
        body: const Center(child: Text('Animal not found')),
      );
    }
    final dateFmt = DateFormat.yMMMd();
    return Scaffold(
      appBar: AppBar(title: Text(a.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _info('Species', a.species.label),
          _info('Born', dateFmt.format(a.birth)),
          _info('Weight', '${a.weightKg} kg'),
          _info('Status', a.status),
          const SizedBox(height: 16),
          const Text('Health log', style: TextStyle(fontWeight: FontWeight.bold)),
          ...a.vaccinations.map((d) => ListTile(
                leading: const Icon(Icons.medical_information),
                title: Text(dateFmt.format(d)),
              )),
          if (a.vaccinations.isEmpty)
            const Text('No vaccinations logged yet',
                style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () async {
              final updated = a.copyWith(
                vaccinations: [...a.vaccinations, DateTime.now()],
              );
              await repo.save(updated);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vaccination logged (offline-first)')),
                );
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('Log vaccination'),
          ),
        ],
      ),
    );
  }

  Widget _info(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            SizedBox(width: 80, child: Text(k, style: const TextStyle(color: Colors.black54))),
            Expanded(child: Text(v, style: const TextStyle(fontWeight: FontWeight.w500))),
          ],
        ),
      );
}
