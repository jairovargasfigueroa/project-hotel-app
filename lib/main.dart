import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/router/app_router.dart';
import 'core/services/api_service.dart';
import 'core/services/storage_service.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/provider/auth_provider.dart';
import 'features/hoteles/data/datasources/hotel_remote_datasource.dart';
import 'features/hoteles/data/repositories/hotel_repository_impl.dart';
import 'features/hoteles/presentation/providers/hotels_provider.dart';
import 'features/habitaciones/data/datasources/habitacion_remote_datasource.dart';
import 'features/habitaciones/data/repositories/habitacion_repository_impl.dart';
import 'features/habitaciones/presentation/providers/habitaciones_provider.dart';
import 'features/reservas/data/datasources/reserva_remote_datasource.dart';
import 'features/reservas/data/repositories/reserva_repository_impl.dart';
import 'features/reservas/presentation/providers/reserva_provider.dart';
import 'features/perfil/data/datasources/perfil_remote_datasource.dart';
import 'features/perfil/data/repositories/hotel_repository_impl.dart';
import 'features/perfil/presentation/providers/perfil_provider.dart';
import 'package:hotel_app/core/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

/// Función para manejar mensajes en background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('🔔 Mensaje recibido en background: ${message.notification?.title}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
   // 🔥 Inicializar Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 🔔 Configurar handler para mensajes en background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 📱 Inicializar servicio de notificaciones
  await NotificationService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Auth Provider - Debe estar primero
        ChangeNotifierProvider(
          create:
              (_) => AuthProvider(
                AuthRepositoryImpl(
                  AuthRemoteDatasource(ApiService()),
                  StorageService(),
                ),
              )..init(), // Inicializar para verificar sesión
        ),
        ChangeNotifierProvider(
          create:
              (_) => HotelsProvider(
                HotelRepositoryImpl(HotelRemoteDatasource(ApiService())),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => HabitacionesProvider(
                HabitacionRepositoryImpl(
                  HabitacionRemoteDatasource(ApiService()),
                ),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => ReservaProvider(
                ReservaRepositoryImpl(ReservaRemoteDatasource(ApiService())),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => PerfilProvider(
                PerfilRepositoryImpl(PerfilRemoteDatasource(ApiService())),
              ),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter,
        title: 'Hotel App',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('es', 'ES'), Locale('en', 'US')],
        locale: const Locale('es', 'ES'),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
    );
  }
}
