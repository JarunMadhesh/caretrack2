import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class HandWash extends StatelessWidget {
  final int no;
  final String content;

  const HandWash(this.no, this.content);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                offset: const Offset(-5.0, -5.0),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                offset: const Offset(5.0, 5.0),
                blurRadius: 10.0,
              ),
            ],
            borderRadius: BorderRadius.circular(50),
            color: const Color(0xffEAEBF3),
          ),
          child: Transform.scale(
            scale: 2,
            child: Image.asset(
              "assets/pictures/hand$no.png",
              fit: BoxFit.fill,
            ),
          ),
        ),
    const SizedBox(height: 10),
        Container(
          width: 120,
          child: AutoSizeText(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Raleway',
              fontSize: 12,
              color: const Color(0xff000000),
            ),
          ),
        )
      ],
    ));
  }
}
