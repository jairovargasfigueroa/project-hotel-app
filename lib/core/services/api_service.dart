import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'storage_service.dart';

class ApiService {
  late final Dio _dio;
  final StorageService _storage = StorageService();

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000/api',
        connectTimeout: Duration(
          milliseconds: int.parse(dotenv.env['API_TIMEOUT'] ?? '30000'),
        ),
        receiveTimeout: Duration(
          milliseconds: int.parse(dotenv.env['API_TIMEOUT'] ?? '30000'),
        ),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Interceptor para agregar token automáticamente a todas las peticiones
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Obtener token del storage
          final token = await _storage.getToken();

          // Si hay token, agregarlo al header
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          // 🏢 Modificar header Host para que Django-tenants detecte el tenant
          // Usamos el dominio que ya tienes en la BD (localhost)
          options.headers['Host'] = 'jairoasoc.localhost';

          return handler.next(options);
        },
        onError: (error, handler) async {
          // Manejo de errores global
          if (error.response?.statusCode == 401) {
            // Token inválido o expirado → Limpiar storage
            await _storage.clear();
          }

          return handler.next(error);
        },
      ),
    );

    // Interceptor para logs (solo en desarrollo)
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) {
          // Imprimir en consola
          print(obj);
        },
      ),
    );
  }

  // GET
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.get(endpoint, queryParameters: queryParameters);
  }

  // POST
  Future<Response> post(String endpoint, dynamic data) async {
    return await _dio.post(endpoint, data: data);
  }

  // PUT
  Future<Response> put(String endpoint, dynamic data) async {
    return await _dio.put(endpoint, data: data);
  }

  // DELETE
  Future<Response> delete(String endpoint) async {
    return await _dio.delete(endpoint);
  }

  // PATCH
  Future<Response> patch(String endpoint, dynamic data) async {
    return await _dio.patch(endpoint, data: data);
  }

  // Getter para acceso directo al Dio
  Dio get dio => _dio;
}
