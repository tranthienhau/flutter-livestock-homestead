import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/animal_detail_screen.dart';
import 'screens/finance_screen.dart';
import 'screens/savings_screen.dart';
import 'screens/add_animal_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
    GoRoute(
      path: '/animal/:id',
      builder: (_, state) => AnimalDetailScreen(id: state.pathParameters['id']!),
    ),
    GoRoute(path: '/finance', builder: (_, __) => const FinanceScreen()),
    GoRoute(path: '/savings', builder: (_, __) => const SavingsScreen()),
    GoRoute(path: '/add', builder: (_, __) => const AddAnimalScreen()),
  ],
);
