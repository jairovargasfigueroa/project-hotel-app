import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/services/api_service.dart';
import 'features/hoteles/data/datasources/hotel_remote_datasource.dart';
import 'features/hoteles/data/repositories/hotel_repository_impl.dart';
import 'features/hoteles/presentation/providers/hotels_provider.dart';
import 'features/hoteles/presentation/screens/hotels_screen.dart';
import 'features/habitaciones/data/datasources/habitacion_remote_datasource.dart';
import 'features/habitaciones/data/repositories/habitacion_repository_impl.dart';
import 'features/habitaciones/presentation/providers/habitaciones_provider.dart';
import 'features/reservas/data/datasources/reserva_remote_datasource.dart';
import 'features/reservas/data/repositories/reserva_repository_impl.dart';
import 'features/reservas/presentation/providers/reserva_provider.dart';
import 'features/perfil/data/datasources/perfil_remote_datasource.dart';
import 'features/perfil/data/repositories/hotel_repository_impl.dart';
import 'features/perfil/presentation/providers/perfil_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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
                PerfilRepositoryImpl(
                  PerfilRemoteDatasource(ApiService()),
                ),
              ),
        ),
      ],
      child: MaterialApp(
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
        home: const HotelsScreen(),
      ),
    );
  }
}
