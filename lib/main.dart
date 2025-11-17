import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'core/services/api_service.dart';
import 'features/hoteles/data/datasources/hotel_remote_datasource.dart';
import 'features/hoteles/data/repositories/hotel_repository_impl.dart';
import 'features/hoteles/presentation/providers/hotels_provider.dart';
import 'features/hoteles/presentation/screens/hotels_screen.dart';

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
      ],
      child: MaterialApp(
        title: 'Hotel App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HotelsScreen(),
      ),
    );
  }
}
