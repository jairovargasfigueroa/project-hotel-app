// lib/core/router/app_router.dart

import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/habitaciones/presentation/screens/habitaciones_screen.dart';
import '../../features/perfil/presentation/screens/perfil_screen.dart';
import '../../features/reservas/presentation/screens/mis_reservas_screen.dart';
import '../services/storage_service.dart';
import 'scaffold_with_nav.dart';

final GoRouter appRouter = GoRouter(
  debugLogDiagnostics: true, // Ver logs en consola
  initialLocation: '/habitaciones',

  // 🔒 Guard para proteger rutas que requieren autenticación
  redirect: (context, state) async {
    final storage = StorageService();
    final isLoggedIn = await storage.hasToken();

    // Si está logueado e intenta ir a login o register → habitaciones
    if (isLoggedIn && (state.matchedLocation == '/login' || state.matchedLocation == '/register')) {
      return '/habitaciones';
    }

    return null; // Permitir navegación
  },

  routes: [
    // 🏠 Shell con Tabs
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        // TAB 0: Habitaciones
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/habitaciones',
              builder: (context, state) => const HabitacionesScreen(),
            ),
          ],
        ),

        // TAB 1: Mis Pedidos
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/mis-reservas',
              builder: (context, state) => const MisReservasScreen(),
            ),
          ],
        ),

        // TAB 2: Perfil
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/perfil',
              builder: (context, state) => const PerfilScreen(),
            ),
          ],
        ),
      ],
    ),

    // Ruta Login (fuera del shell de tabs)
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

    // Ruta Register (fuera del shell de tabs)
    GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
  ],
);
