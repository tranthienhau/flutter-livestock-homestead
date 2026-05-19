import 'species.dart';

class Animal {
  final String id;
  final Species species;
  final String name;
  final DateTime birth;
  final double weightKg;
  final String status;
  final List<DateTime> vaccinations;

  const Animal({
    required this.id,
    required this.species,
    required this.name,
    required this.birth,
    required this.weightKg,
    required this.status,
    this.vaccinations = const [],
  });

  Animal copyWith({double? weightKg, String? status, List<DateTime>? vaccinations}) => Animal(
        id: id,
        species: species,
        name: name,
        birth: birth,
        weightKg: weightKg ?? this.weightKg,
        status: status ?? this.status,
        vaccinations: vaccinations ?? this.vaccinations,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'species': species.name,
        'name': name,
        'birth': birth.toIso8601String(),
        'weightKg': weightKg,
        'status': status,
        'vaccinations': vaccinations.map((d) => d.toIso8601String()).toList(),
      };

  factory Animal.fromJson(Map<dynamic, dynamic> j) => Animal(
        id: j['id'] as String,
        species: Species.values.firstWhere((s) => s.name == j['species']),
        name: j['name'] as String,
        birth: DateTime.parse(j['birth'] as String),
        weightKg: (j['weightKg'] as num).toDouble(),
        status: j['status'] as String,
        vaccinations: ((j['vaccinations'] as List?) ?? const [])
            .map((d) => DateTime.parse(d as String))
            .toList(),
      );
}
