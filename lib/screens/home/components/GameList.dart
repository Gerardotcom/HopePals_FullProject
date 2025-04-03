import 'package:flutter/material.dart';
import 'package:hopepals_game/screens/home/home_screen.dart';

// Definición de las listas de juegos
final List<Game> games = [
  Game(
    title: "FlappyBird",
    color: Color(0xFF7553F6),
    imageSrc: "assets/images/games/GameFlappyBird.png",
  ),
  Game(
    title: "The body",
    color: Color(0xFF42A5F5),
    imageSrc: "assets/images/games/GameFlappyBird.png",
  ),
];

final List<Game> recentGames = [
  Game(
    title: "Recent Game 1",
    color: Color(0xFFFF7043),
    imageSrc: "assets/images/games/GameFlappyBird.png",
  ),
  Game(
    title: "Recent Game 2",
    color: Color(0xFF66BB6A),
    imageSrc: "assets/images/games/GameFlappyBird.png",
  ),
  // Agrega más juegos recientes si es necesario
];