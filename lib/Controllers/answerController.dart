import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AnswerController {
  static const int maxResponseLength = 200;

  static String formatResponse(String response) {
    // Implementación de la función aquí
    String formatted = response
        .replaceAllMapped(
      RegExp(r'\*\*(.*?)\*\*'),
          (match) => '<b>${match.group(1)}</b>',
    )
        .replaceAllMapped(
      RegExp(r'\*(.*?)\*'),
          (match) => match.group(1) ?? '',
    );

    if (formatted.length > maxResponseLength) {
      formatted = formatted.substring(0, maxResponseLength) + '...';
    }

    return formatted;
  }
}

