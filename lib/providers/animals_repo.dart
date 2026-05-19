import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/animal.dart';
import '../models/species.dart';

class AnimalsRepo {
  final Box _box;
  AnimalsRepo(this._box);

  List<Animal> all() {
    return _box.values
        .whereType<Map>()
        .map(Animal.fromJson)
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  Future<void> save(Animal a) => _box.put(a.id, a.toJson());

  Future<void> delete(String id) => _box.delete(id);

  Animal? byId(String id) {
    final raw = _box.get(id);
    if (raw is Map) return Animal.fromJson(raw);
    return null;
  }

  Future<void> seed() async {
    if (_box.isNotEmpty) return;
    const uuid = Uuid();
    final now = DateTime.now();
    final samples = [
      Animal(
        id: uuid.v4(),
        species: Species.chicken,
        name: 'Henrietta',
        birth: now.subtract(const Duration(days: 240)),
        weightKg: 2.1,
        status: 'Laying',
      ),
      Animal(
        id: uuid.v4(),
        species: Species.goat,
        name: 'Marigold',
        birth: now.subtract(const Duration(days: 540)),
        weightKg: 38.5,
        status: 'Milking',
      ),
    ];
    for (final a in samples) {
      await save(a);
    }
  }
}

final animalsBoxProvider = Provider<Box>((ref) => Hive.box('animals'));

final animalsRepoProvider = Provider<AnimalsRepo>((ref) {
  return AnimalsRepo(ref.watch(animalsBoxProvider));
});

final animalsListProvider = FutureProvider<List<Animal>>((ref) async {
  final repo = ref.watch(animalsRepoProvider);
  await repo.seed();
  return repo.all();
});
