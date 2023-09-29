import 'package:flutter/material.dart';
import 'package:listeny/constants/constants.dart';

RichText logoText() {
  return RichText(
    text: TextSpan(
      children: [
        orangeText('Li'),
        whiteText('St'),
        orangeText('E'),
        whiteText('nY')
      ],
    ),
  );
}

orangeText(data) {
  return TextSpan(
    text: data,
    style: const TextStyle(
      color: themeColor,
      fontSize: 40,
      fontWeight: FontWeight.bold,
    ),
  );
}

whiteText(data) {
  return TextSpan(
    text: data,
    style: const TextStyle(
      color: textColor,
      fontSize: 40,
      fontWeight: FontWeight.bold,
    ),
  );
}
