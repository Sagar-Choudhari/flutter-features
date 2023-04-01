import 'package:features/app/index.dart';
import 'package:features/features/get_imei.dart';
import 'package:features/features/internet_check.dart';
import 'package:features/features/location.dart';
import 'package:features/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'features/note.dart';
import 'features/shared_preferences.dart';

void main() async {
  await NotificationController.initializeLocalNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Features Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const MyHomePage(),
        '/internet': (context) => const InternetCheck(),
        '/imei': (context) => const CheckImei(),
        '/location': (context) => const GetLocation(),
        '/note': (context) => const Note(),
        '/pref': (context) => const SharedPref(),
        '/tPdf': (context) => const TablePdf(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      debugPrint("Firebase initialized successfully");
    } catch (e) {
      debugPrint("Error initializing Firebase: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('widget.title'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Features Demo',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/internet');
              },
              child: const Text('Check Internet Status'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/imei');
              },
              child: const Text('Check IMEI Number'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/location');
              },
              child: const Text('Check Location'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/note');
                /*Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const Note())
                );*/
              },
              child: const Text('Check Notification and badge'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/pref');
              },
              child: const Text('Check Shared Preferences'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/tPdf');
              },
              child: const Text('Check PDF App'),
            ),
          ],
        ),
      ),
    );
  }
}
