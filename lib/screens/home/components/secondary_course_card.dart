import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SecondaryGameCard extends StatelessWidget {
  const SecondaryGameCard({
    super.key,
    required this.title,
    this.iconSrc = "assets/icons/code.svg",  // Default icon, puedes cambiarlo
    this.color = const Color(0xFF7553F6),  // Color principal
    this.imageSrc = "assets/images/games/GameFlappyBird.png", // Imagen del juego
  });

  final String title, iconSrc, imageSrc;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Aquí puedes agregar la lógica para navegar a otra pantalla
        Navigator.pushNamed(context, '/gameDetails'); // Asegúrate de definir la ruta
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          children: [
            // Imagen del juego
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imageSrc,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            // Título del juego
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Descripción corta o información adicional
            const Text(
              "Play Now!",
              style: TextStyle(
                color: Colors.white60,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            // Icono del juego (puedes usar SVG o una imagen)
            SvgPicture.asset(
              iconSrc,
              width: 24,
              height: 24,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
