import 'package:azan_app/features/adhan/presentation/azan_screen.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouter {
  static final router = GoRouter(
    routes: <RouteBase>[
      GoRoute(path: '/', builder: (context, state) => const AzanScreen()),
    ],
  );
}
