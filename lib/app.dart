import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_poultry_farm/screens/home.dart';
import 'package:smart_poultry_farm/screens/splash.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

const String channelId = "default_channel";
const AndroidNotificationChannel channel =
    AndroidNotificationChannel(channelId, "Default", "default channel for SPF");

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class SPFApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: FutureBuilder<Widget>(
        initialData: Splash(),
        future: findHome(),
        builder: (context, ss) => ss.data,
      ),
    );
  }

  Future<Widget> findHome() async {
    await Firebase.initializeApp();
    _doAfterInitFirebase();
    await Future.delayed(Duration(seconds: 3));
    final dbRef = FirebaseDatabase(
            databaseURL:
                "https://fir-p-f-b0543-default-rtdb.europe-west1.firebasedatabase.app/")
        .reference();

    saveToken(dbRef.child("tokens"));

    return Home(
      ventilationRef: dbRef.child("ventilation"),
      lightsRef: dbRef.child("lights"),
      cleaningRef: dbRef.child("cleaning"),
      nutritionRef: dbRef.child("nutrition"),
      hydrationRef: dbRef.child("hydration"),
    );
  }

  void _doAfterInitFirebase() async {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    final settings = InitializationSettings(
        android: AndroidInitializationSettings('ic_launcher'));

    await flutterLocalNotificationsPlugin.initialize(settings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        await flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: android?.smallIcon,
                // other properties...
              ),
            ));
      }
    });
  }

  void saveToken(DatabaseReference tokensRef) async {
    final tokens = await tokensRef.once();
    final tokensList = (tokens.value as List).cast<String>().toSet();
    print(tokensList);
    final token = await FirebaseMessaging.instance.getToken(
        vapidKey:
            "BD3rtsgI6FQw23ZCmC_T2wx4kebxE8zNMPve_ZP-HQLqZHnsePLoEy2GXTZ0FAa-c1gXbXgzyWDnpBtF0WkHzik");
    tokensList.add(token);
    await tokensRef.set(tokensList.toList());
  }
}
