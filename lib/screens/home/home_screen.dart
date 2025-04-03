import 'package:flutter/material.dart';
import '../../model/course.dart';
import 'components/course_card.dart'; // Asumiendo que esta es la card para el juego
import 'components/secondary_course_card.dart'; // Usamos SecondaryGameCard
import 'package:hopepals_game/screens/home/components/GameList.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x24000000),
      appBar: AppBar(
        title: Text('Juegos'),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          // Contenido principal de la página
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0), // Padding global
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20), // Espaciado entre secciones
                    Text(
                      "Recientes",
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10), // Espaciado entre secciones
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: games
                            .map(
                              (game) => Padding(
                            padding: const EdgeInsets.only(right: 10.0), // Espaciado entre tarjetas
                            child: GameCard(
                              title: game.title,
                              imageSrc: game.imageSrc,
                            ),
                          ),
                        )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 20), // Espaciado entre secciones
                    Text(
                      "Todos los juegos",
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10), // Espaciado entre secciones
                    ...recentGames.map(
                          (game) => Padding(
                        padding: const EdgeInsets.only(bottom: 20.0), // Espaciado entre tarjetas
                        child: SecondaryGameCard(
                          title: game.title,
                          imageSrc: game.imageSrc,
                          color: game.color,
                        ),
                      ),
                    ),
                    const SizedBox(height: kBottomNavigationBarHeight + 5), // Espaciado entre secciones
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Definimos una clase Game para manejar los datos del juego
class Game {
  final String title;
  final Color color;
  final String imageSrc;

  Game({
    required this.title,
    required this.color,
    required this.imageSrc,
  });
}
