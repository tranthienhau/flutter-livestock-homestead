enum Species { chicken, goat, cow, sheep, pig, rabbit, bee, garden }

extension SpeciesLabel on Species {
  String get label {
    switch (this) {
      case Species.chicken: return 'Chicken';
      case Species.goat: return 'Goat';
      case Species.cow: return 'Cow';
      case Species.sheep: return 'Sheep';
      case Species.pig: return 'Pig';
      case Species.rabbit: return 'Rabbit';
      case Species.bee: return 'Bee colony';
      case Species.garden: return 'Garden bed';
    }
  }
}
