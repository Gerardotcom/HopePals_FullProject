import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hopepals_game/Games/FlappyMounster.dart'; // Importa tu pantalla de juego

class GameCard extends StatelessWidget {
  const GameCard({
    super.key,
    required this.title,
    this.iconSrc = "assets/icons/game_icon.svg",  // Default icon, puedes cambiarlo
    this.color = const Color(0xFF7553F6),  // Color principal
    this.imageSrc = "assets/images/games/GameFlappyBird.png", // Imagen del juego
  });

  final String title, imageSrc, iconSrc;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Al tocar la tarjeta, navega al juego
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GameScreen()), // Reemplaza con la pantalla correspondiente
        );
      },
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          border: Border.all(color: Colors.white, width: 2),
          image: DecorationImage(
            image: AssetImage(imageSrc), // Imagen del fondo
            fit: BoxFit.cover,
          ),
        ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2), // Fondo claro con opacidad
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                    ),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
      ),
    );
  }
}

