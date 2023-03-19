import 'package:flutter/material.dart';
import 'package:map_markers/modules/colors.dart';
import 'package:map_markers/widgets/app_bar.dart';

class Info extends StatelessWidget {
  final String title;
  final String about;

  const Info({super.key, required this.title, required this.about});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: title),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 17.0),
                const ColoredText(text: "About us", size: 40.0, color: primeColor,),
                const SizedBox(height: 5),
                Expanded(child: ColoredText(text: about, size: 17, color: primeColor,)),
                const InfoCard(
                  name: "Laura-Eliise Marrandi",
                  eMail: "laura-eliise@marrandi.ee",
                  url: "assets/images/laura-eliise.jpeg",
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const InfoCard(
                    name: "Gunta Kļava",
                    eMail: "gukka@gamil.com",
                    url: "assets/images/gunta.jpg"),
                const Expanded(child: SizedBox())
              ],
            )),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String name;
  final String eMail;
  final String url;

  const InfoCard(
      {super.key, required this.name, required this.eMail, required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: primeGradient, borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  ColoredText(
                    text: name,
                    size: 20,
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  ColoredText(
                    text: eMail,
                    size: 15,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            RoundedImage(
              url: url,
              rounding: 20.0,
            )
          ],
        ),
      ),
    );
  }
}

class RoundedImage extends StatelessWidget {
  final String url;
  final double rounding;

  const RoundedImage({super.key, required this.url, required this.rounding});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(rounding),
        child: AspectRatio(
          aspectRatio: 500 / 500,
          child: Image.asset(
            url,
            fit: BoxFit.fitWidth,
            alignment: const FractionalOffset(0.2, 0.2),
          ),
        ),
      ),
    );
  }
}

class ColoredText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;

  const ColoredText(
      {super.key,
      required this.text,
      required this.size,
      this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
          TextStyle(fontSize: size, fontWeight: FontWeight.w700, color: color),
      textAlign: TextAlign.center,
    );
  }
}
