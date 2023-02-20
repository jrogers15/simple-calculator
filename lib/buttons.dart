import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final color;
  final textColor;
  final String buttonText;
  final buttonTapped;

  MyButton(
      {this.color,
      this.textColor,
      required this.buttonText,
      this.buttonTapped});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: buttonTapped,
        child: Padding(
            padding: const EdgeInsets.all(0.5),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                    color: color,
                    child: Center(
                        child: Text(buttonText,
                            style: TextStyle(
                              fontSize: 25,
                              color: textColor,
                              fontWeight: FontWeight.bold,
                            )))))));
  }
}
