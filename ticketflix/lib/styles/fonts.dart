import 'package:flutter/material.dart';
import 'colors.dart';

class Style {
  static const cera = TextStyle(fontFamily: 'cera');
  static const mada = TextStyle(fontFamily: 'mada');
  static const raleway = TextStyle(fontFamily: 'raleway');
  static const ubuntu = TextStyle(fontFamily: 'ubuntu');
  static const noto = TextStyle(
      fontFamily: 'noto-sans', fontSize: 14, fontWeight: FontWeight.w400);
  static final cerabold = cera.copyWith(fontWeight: FontWeight.bold);
  static final madabold = mada.copyWith(fontWeight: FontWeight.bold);

  static const title = TextStyle(
      fontFamily: 'cera',
      color: primary_text,
      fontSize: 15,
      fontWeight: FontWeight.bold);

  static const cantarell = TextStyle(fontFamily: 'cantarell');
  static final cantarellbold = cera.copyWith(fontWeight: FontWeight.bold);
}

class DynamicFont extends StatelessWidget {
  final String text;

  const DynamicFont({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final fontScaleFactor =
        12.0 * devicePixelRatio; // adjust this value as needed

    return Text(
      text,
      style: TextStyle(
        fontFamily: 'noto-sans',
        fontSize: fontScaleFactor,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
