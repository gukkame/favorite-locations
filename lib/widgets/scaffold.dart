import 'package:flutter/material.dart';
import 'app_bar.dart';
import '../modules/colors.dart';

class RoundScaffold extends StatelessWidget {
  final Widget? child;
  final String title;
  final double rounding;

  const RoundScaffold(
      {Key? key, required this.title, required this.rounding, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primeColor,
      appBar: CustomAppBar(title: title),
      body: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(rounding),
                topRight: Radius.circular(rounding)),
            color: Colors.white),
        child: child,
      ),
    );
  }
}
