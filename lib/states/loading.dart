import 'dart:async';
import 'package:flutter/material.dart';

import '../modules/colors.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: primeMaterialColor),
      home: Scaffold(
          body: Center(
        child: Container(
          color: Colors.white,
          child: const LoadingAnimation(),
        ),
      )),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoadingAnimation extends StatefulWidget {
  const LoadingAnimation({super.key});

  @override
  State<StatefulWidget> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation> {
  int _dotCount = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (Timer timer) {
      setState(() {
        _dotCount++;
        if (_dotCount > 2) {
          _dotCount = 0;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String loadingText = 'Loading';
    for (int i = 0; i <= _dotCount; i++) {
      loadingText += '.';
    }
    return Text(
      loadingText,
      style: const TextStyle(
          fontSize: 40.0, fontWeight: FontWeight.bold, color: primeColor),
    );
  }
}

Widget smallLoading = const Center(
    child: Padding(
  padding: EdgeInsets.only(top: 2),
  child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(primeColor)),
));
