import 'package:flutter/material.dart';

class SplashContent extends StatefulWidget {
  const SplashContent({
    super.key,
    this.text,
    this.image,
  });
  final String? text, image;

  @override
  State<SplashContent> createState() => _SplashContentState();
}

class _SplashContentState extends State<SplashContent> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;

    return Column(
      children: <Widget>[
        const Spacer(),
        Text(
          "Akash Padiyar",
          style: TextStyle(
            fontSize: width * 0.10,
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "Tutorials",
          style: TextStyle(
            fontSize: width * 0.08,
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Text(
            widget.text!,
            textAlign: TextAlign.center,
            style:
                TextStyle(fontSize: width * 0.051, fontWeight: FontWeight.w600),
          ),
        ),
        Image.asset(
          widget.image!,
          height: height * 0.35,
          width: width * 0.8,
        ),
        const Spacer(),
      ],
    );
  }
}
