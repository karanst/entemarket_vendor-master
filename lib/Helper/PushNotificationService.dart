import 'package:ziberto_vendor/Helper/ApiBaseHelper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'Session.dart';
import 'String.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
FirebaseMessaging messaging = FirebaseMessaging.instance;
Future<void> backgroundMessage(RemoteMessage message) async {
  print(message);

}

class PushNotificationService {
  late BuildContext context;
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  PushNotificationService({required this.context});

//==============================================================================
//============================= initialise =====================================

  Future initialise() async {
    print("initialise");
    iOSPermission();
    messaging.getToken().then(
      (token) async {
        if (CUR_USERID != null && CUR_USERID != "") _registerToken(token);
      },
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings();
    final MacOSInitializationSettings initializationSettingsMacOS =
    MacOSInitializationSettings();
    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {

        });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      print("0k"+message.toString());
      var data = message.notification!;
      print("cehed"+data.toString());
      var title = data.title.toString();
      var body = data.body.toString();
      var test = message.data;
      if(title.toString().toLowerCase().contains("accepted")||body.toString().toLowerCase().contains("accepted")){

      }
      if(title.toString().toLowerCase().contains("completed")||body.toString().toLowerCase().contains("completed")){

      }
      print(test);
      print(test['Booking_id']);

      generateSimpleNotication(title, body, "");
      /* if (type == "ticket_status") {

      } else if (type == "ticket_message") {

          if (image != null && image != 'null' && image != '') {
            generateImageNotication(title, body, image, type, id);
          } else {
            generateSimpleNotication(title, body, type, id);
          }
      } else if (image != null && image != 'null' && image != '') {
        generateImageNotication(title, body, image, type, id);
      } else {
        generateSimpleNotication(title, body, type, id);
      }*/
    });

    messaging.getInitialMessage().then((RemoteMessage? message) async {
      await Future.delayed(Duration.zero);
      if(message!=null){
        var data = message.notification!;
        print("cehed"+data.toString());
        var title = data.title.toString();
        var body = data.body.toString();
        if(title.toString().toLowerCase().contains("accepted")||body.toString().toLowerCase().contains("accepted")){

        }
        if(title.toString().toLowerCase().contains("completed")||body.toString().toLowerCase().contains("completed")){

        }
      }

    });

    FirebaseMessaging.onBackgroundMessage(backgroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

    });
  }

//==============================================================================
//========================= iOSPermission ======================================
//done

  void iOSPermission() async {

    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

//==============================================================================
//========================= _registerToken =====================================

  void _registerToken(String? token) async {


    var parameter = {
      'user_id': CUR_USERID,
      FCMID: token,
    };
    print(parameter);
    apiBaseHelper.postAPICall(updateFcmApi, parameter).then(
      (getdata) async {

      },
      onError: (error) {},
    );
  }
}

//done above

//==============================================================================
//========================= myForgroundMessageHandler ==========================

Future<dynamic> myForgroundMessageHandler(RemoteMessage message) async {

  return Future<void>.value();
}

//==============================================================================
//========================= generateSimpleNotication ===========================

Future<void> generateSimpleNotication(
    String title, String body, String type) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'default_notification_channel',
    'your channel name',
    channelDescription: 'your channel description',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
    playSound: true,
    enableVibration: true,
    enableLights: true,
    color: const Color.fromARGB(255, 255, 0, 0),
    ledColor: const Color.fromARGB(255, 255, 0, 0),
    ledOnMs: 1000,
    ledOffMs: 500,
    sound: RawResourceAndroidNotificationSound('test'),

  );
  var iosDetail = IOSNotificationDetails();

  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics, iOS: iosDetail);
  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    platformChannelSpecifics,
    payload: type,
  );
}

//==============================================================================
//==============================================================================
