

import 'package:flutter/material.dart';

BoxDecoration commonBackgroundGradientColor() {
  return const BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color(0xFF0f2027),
        Color(0xFF203a43),
        Color(0xFF2c5364),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
}

 const commonBackgroundColor = Color(0xFF0f2027);
