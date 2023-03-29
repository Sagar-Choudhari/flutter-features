import 'package:features/features/get_imei.dart';
import 'package:features/features/internet_check.dart';
import 'package:features/features/location.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Features Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        '/internet': (context) => const InternetCheck(),
        '/imei': (context) => const CheckImei(),
        '/location': (context) => const GetLocation(),
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
                child: const Text('Check Internet Status'),),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/imei');
                },
                child: const Text('Check IMEI Number'),),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/location');
              },
              child: const Text('Check Location'),),
          ],
        ),
      ),
    );
  }
}
