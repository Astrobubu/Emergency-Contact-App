import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  bool _isServiceRunning = false;

  Future<void> initialize() async {
    final service = FlutterBackgroundService();

    // Configure notification for Android foreground service
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'my_foreground', // id
      'Location Service', // title
      description: 'Sharing location with family', // description
      importance: Importance.low,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
          
      // Create notification channel
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      await service.configure(
        androidConfiguration: AndroidConfiguration(
          onStart: onStart,
          autoStart: false, // Don't auto-start, let user enable it
          isForegroundMode: true,
          notificationChannelId: 'my_foreground',
          initialNotificationTitle: 'Family Emergency Hub',
          initialNotificationContent: 'Initializing location service...',
          foregroundServiceNotificationId: 888,
        ),
        iosConfiguration: IosConfiguration(
          autoStart: false,
          onForeground: onStart,
          onBackground: onIosBackground,
        ),
      );
    }
  }

  Future<void> startService() async {
    final service = FlutterBackgroundService();
    if (!await service.isRunning()) {
      service.startService();
      _isServiceRunning = true;
    }
  }

  Future<void> stopService() async {
    final service = FlutterBackgroundService();
    if (await service.isRunning()) {
      service.invoke("stopService");
      _isServiceRunning = false;
    }
  }

  // Determine position permissions
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}

// Global function for background execution
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // Bring to foreground
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
      
  // Periodically update location
  Timer.periodic(const Duration(minutes: 5), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        flutterLocalNotificationsPlugin.show(
          888,
          'Family Emergency Hub',
          'Updated location at ${DateTime.now()}',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'my_foreground',
              'Location Service',
              icon: 'ic_bg_service_small',
              ongoing: true,
            ),
          ),
        );
      }
    }

    // TODO: Send location to Supabase here
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print('Location updated: ${position.latitude}, ${position.longitude}');
      
      // Here you would upload to Supabase:
      // Supabase.instance.client.from('location_updates').insert({...})
      
    } catch (e) {
      print('Error getting location: $e');
    }
  });
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  // iOS background handling
  return true;
}
