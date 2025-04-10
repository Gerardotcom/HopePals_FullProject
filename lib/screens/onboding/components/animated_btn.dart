import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class AnimatedBtn extends StatelessWidget {
  const AnimatedBtn({
    super.key,
    required RiveAnimationController btnAnimationController,
    required this.press,
  }) : _btnAnimationController = btnAnimationController;

  final RiveAnimationController _btnAnimationController;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        height: 64,
        width: 236,
        child: Stack(
          children: [
            // Animación Rive con controlador
            RiveAnimation.asset(
              "assets/RiveAssets/button.riv",
              controllers: [_btnAnimationController],
              fit: BoxFit.cover, // Esto asegura que la animación se ajuste correctamente
            ),
            // Contenido del botón
            Positioned.fill(
              top: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.arrow_right),
                  const SizedBox(width: 8),
                  Text(
                    "Iniciar Sesion",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.black87, // Asegúrate de que el texto sea legible
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
