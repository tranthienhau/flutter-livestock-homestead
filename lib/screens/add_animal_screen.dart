import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/animal.dart';
import '../models/species.dart';
import '../providers/animals_repo.dart';

class AddAnimalScreen extends ConsumerStatefulWidget {
  const AddAnimalScreen({super.key});
  @override
  ConsumerState<AddAnimalScreen> createState() => _AddAnimalScreenState();
}

class _AddAnimalScreenState extends ConsumerState<AddAnimalScreen> {
  final _name = TextEditingController();
  final _weight = TextEditingController(text: '0');
  Species _species = Species.chicken;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add animal')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<Species>(
            initialValue: _species,
            items: Species.values
                .map((s) => DropdownMenuItem(value: s, child: Text(s.label)))
                .toList(),
            onChanged: (v) => setState(() => _species = v ?? Species.chicken),
            decoration: const InputDecoration(labelText: 'Species'),
          ),
          const SizedBox(height: 12),
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name')),
          const SizedBox(height: 12),
          TextField(
            controller: _weight,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Weight (kg)'),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () async {
              final repo = ref.read(animalsRepoProvider);
              await repo.save(Animal(
                id: const Uuid().v4(),
                species: _species,
                name: _name.text,
                birth: DateTime.now(),
                weightKg: double.tryParse(_weight.text) ?? 0,
                status: 'Active',
              ));
              ref.invalidate(animalsListProvider);
              if (context.mounted) Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
