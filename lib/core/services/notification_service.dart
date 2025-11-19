import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class NotificationService {
  static final ApiService _apiService = ApiService();
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Inicializar el servicio de notificaciones
  static Future<void> initialize() async {
    try {
      // 1. Solicitar permisos
      await _requestPermissions();

      // 2. Configurar notificaciones locales
      await _initializeLocalNotifications();

      // 3. Configurar listeners de mensajes
      _setupMessageHandlers();

      // 4. Configurar listener para cambios de token
      _setupTokenRefreshListener();

      // 5. Obtener token FCM
      await _getAndPrintToken();

      // 6. Verificar y enviar token si es necesario
      await checkAndUpdateTokenIfNeeded();

      print('✅ Servicio de notificaciones inicializado correctamente');
    } catch (e) {
      print('❌ Error al inicializar notificaciones: $e');
    }
  }

  /// Solicitar permisos de notificación
  static Future<void> _requestPermissions() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ Permisos de notificación concedidos');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('⚠️ Permisos de notificación provisionales concedidos');
    } else {
      print('❌ Permisos de notificación denegados');
    }
  }

  /// Inicializar notificaciones locales
  static Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Manejar cuando el usuario toca la notificación
        _handleNotificationTap(response);
      },
    );

    // Crear canal de notificación para Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'Notificaciones Importantes',
      description: 'Canal para notificaciones importantes de la app',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  /// Configurar listeners de mensajes de Firebase
  static void _setupMessageHandlers() {
    // Cuando la app está en primer plano (foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
        '📱 Mensaje recibido en primer plano: ${message.notification?.title}',
      );
      _showLocalNotification(message);
    });

    // Cuando el usuario toca una notificación (app en background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('🔔 Notificación tocada: ${message.notification?.title}');
      _handleMessageTap(message);
    });

    // Comprobar si la app fue abierta desde una notificación
    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message != null) {
        print(
          '🚀 App abierta desde notificación: ${message.notification?.title}',
        );
        _handleMessageTap(message);
      }
    });
  }

  /// Escuchar cambios de token automáticos
  static void _setupTokenRefreshListener() {
    _messaging.onTokenRefresh.listen((newToken) {
      print(
        '🔄 Token actualizado automáticamente: ${newToken.substring(0, 20)}...',
      );
      _sendTokenToBackend(newToken);
      _saveTokenLocally(newToken);
    });
  }

  /// Obtener y mostrar el token FCM
  static Future<void> _getAndPrintToken() async {
    String? token = await _messaging.getToken();
    print('🔑 TOKEN FCM: $token');
    print('📋 Copia este token para enviar notificaciones de prueba');
  }

  /// Mostrar notificación local cuando la app está en primer plano
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'high_importance_channel',
          'Notificaciones Importantes',
          channelDescription: 'Canal para notificaciones importantes de la app',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'Nueva notificación',
      message.notification?.body ?? 'Tienes un nuevo mensaje',
      platformChannelSpecifics,
      payload: message.data.toString(),
    );
  }

  /// Manejar cuando el usuario toca una notificación local
  static void _handleNotificationTap(NotificationResponse response) {
    print('👆 Notificación local tocada: ${response.payload}');
    // Aquí puedes navegar a una pantalla específica
  }

  /// Manejar cuando el usuario toca una notificación de Firebase
  static void _handleMessageTap(RemoteMessage message) {
    print('👆 Notificación Firebase tocada: ${message.data}');
    // Aquí puedes navegar a una pantalla específica
    // Ejemplo: Get.toNamed('/notifications', arguments: message.data);
  }

  /// Obtener el token FCM actual
  static Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  /// Suscribirse a un topic
  static Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    print('✅ Suscrito al topic: $topic');
  }

  /// Desuscribirse de un topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    print('❌ Desuscrito del topic: $topic');
  }

  // 🔥 NUEVAS FUNCIONES PARA MANEJO DE TOKEN CON BACKEND

  /// Verificar y enviar token al backend si es necesario
  static Future<void> checkAndUpdateTokenIfNeeded() async {
    String? currentToken = await _messaging.getToken();
    String? savedToken = await _getSavedToken();

    if (savedToken == null || currentToken != savedToken) {
      print('📤 Token cambió o es primera vez, enviando al backend...');
      await _sendTokenToBackend(currentToken);
      await _saveTokenLocally(currentToken);
    } else {
      print('✅ Token no cambió, no es necesario actualizar backend');
    }
  }

  /// 🔄 FORZAR generación de nuevo token y enviarlo al backend
  /// Usado cuando un usuario se loguea para asegurar token único por usuario
  static Future<void> forceTokenRefreshAndSend() async {
    try {
      print('🔄 Forzando regeneración de FCM token para nuevo usuario...');

      // 1. Eliminar token anterior de Firebase
      await _messaging.deleteToken();
      print('🗑️ Token anterior eliminado');

      // 2. Generar nuevo token
      String? newToken = await _messaging.getToken();
      print('✨ Nuevo FCM token generado: ${newToken?.substring(0, 20)}...');

      // 3. Enviar nuevo token al backend
      await _sendTokenToBackend(newToken);

      // 4. Guardar nuevo token localmente
      await _saveTokenLocally(newToken);

      print('✅ Token regenerado y enviado exitosamente');
    } catch (e) {
      print('❌ Error regenerando token FCM: $e');
    }
  }

  /// Obtener token guardado localmente
  static Future<String?> _getSavedToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('fcm_token');
    } catch (e) {
      print('❌ Error obteniendo token guardado: $e');
      return null;
    }
  }

  /// Guardar token localmente
  static Future<void> _saveTokenLocally(String? token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (token != null) {
        await prefs.setString('fcm_token', token);
        print('💾 Token guardado localmente');
      }
    } catch (e) {
      print('❌ Error guardando token localmente: $e');
    }
  }

  /// Enviar token al backend Django
  static Future<void> _sendTokenToBackend(String? token) async {
    if (token == null) {
      print('❌ No se puede enviar token nulo al backend');
      return;
    }

    try {
      // Usar ApiService con Dio
      final response = await _apiService.post(
        '/usuarios/actualizar_token_fcm/',
        {'fcm_token': token},
      );

      if (response.statusCode == 200) {
        print('✅ Token FCM enviado exitosamente al backend');
      } else {
        print('❌ Error enviando token FCM al backend: ${response.statusCode}');
        print('   Response: ${response.data}');
      }
    } catch (e) {
      print('❌ Error de conexión enviando token FCM al backend: $e');
    }
  }

  /// Eliminar token del backend (usado en logout)
  static Future<void> removeTokenFromBackend() async {
    try {
      print('🗑️ Eliminando token FCM del backend...');

      // Enviar null al backend para eliminar el token
      final response = await _apiService.post(
        '/usuarios/actualizar_token_fcm/',
        {'fcm_token': null},
      );

      if (response.statusCode == 200) {
        print('✅ Token FCM eliminado exitosamente del backend');

        // Limpiar token guardado localmente
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('fcm_token');
        print('💾 Token eliminado localmente');
      } else {
        print(
          '❌ Error eliminando token FCM del backend: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ Error de conexión eliminando token FCM: $e');
    }
  }
}
