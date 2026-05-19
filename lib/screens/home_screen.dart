import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/species.dart';
import '../providers/animals_repo.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAnimals = ref.watch(animalsListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homestead'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance_wallet),
            onPressed: () => context.push('/finance'),
          ),
          IconButton(
            icon: const Icon(Icons.savings),
            onPressed: () => context.push('/savings'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add animal'),
      ),
      body: asyncAnimals.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (animals) {
          if (animals.isEmpty) {
            return const Center(child: Text('No animals yet'));
          }
          final bySpecies = <Species, List<dynamic>>{};
          for (final a in animals) {
            bySpecies.putIfAbsent(a.species, () => []).add(a);
          }
          return ListView(
            padding: const EdgeInsets.all(8),
            children: bySpecies.entries.map((entry) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(_iconFor(entry.key)),
                          const SizedBox(width: 8),
                          Text(entry.key.label,
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          const Spacer(),
                          Text('${entry.value.length}'),
                        ],
                      ),
                      const Divider(),
                      ...entry.value.map((a) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(a.name),
                            subtitle: Text('${a.weightKg} kg · ${a.status}'),
                            onTap: () => context.push('/animal/${a.id}'),
                          )),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  IconData _iconFor(Species s) {
    switch (s) {
      case Species.chicken: return Icons.egg;
      case Species.goat: return Icons.pets;
      case Species.cow: return Icons.agriculture;
      case Species.sheep: return Icons.cloud;
      case Species.pig: return Icons.cruelty_free;
      case Species.rabbit: return Icons.spa;
      case Species.bee: return Icons.bug_report;
      case Species.garden: return Icons.local_florist;
    }
  }
}
