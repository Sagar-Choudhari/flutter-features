import 'package:features/main.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: (5)),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Lottie.asset(
          'assets/90751-android-app-background.json',
          controller: _controller,
          height: MediaQuery.of(context).size.height,
          animate: true,
          fit: BoxFit.cover,
          onLoaded: (composition) {
            _controller
              ..duration = composition.duration
              ..forward().whenComplete(() => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MyHomePage()),
                  ));
          },
        ),
        const Center(
          child: Text(
            'Features',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontFamily: 'Caveat',
              shadows: [
                Shadow(
                    offset: Offset(0, 0),
                    color: Colors.black38,
                    blurRadius: 20),
              ],
              color: Colors.black,
              letterSpacing: 10,
            ),
          ),
        ),
      ],
    ));
  }
}
