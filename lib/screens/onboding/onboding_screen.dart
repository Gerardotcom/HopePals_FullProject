import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import 'components/animated_btn.dart';
import 'components/sign_in_dialog.dart';

class OnbodingScreen extends StatefulWidget {
  const OnbodingScreen({super.key});

  @override
  State<OnbodingScreen> createState() => _OnbodingScreenState();
}

class _OnbodingScreenState extends State<OnbodingScreen> {
  late RiveAnimationController _animationController;
  late RiveAnimationController _btnAnimationController;
  bool _isAnimationComplete = false;
  bool isShowSignInDialog = false;
  bool _showButton = false;

  @override
  void initState() {
    super.initState();

    // Controlador para la animación de Rive
    _animationController = OneShotAnimation(
      "StartAnim", // Nombre de la animación
      autoplay: true,
      onStop: () {
        setState(() {
          _isAnimationComplete = true;
        });
      },
    );

    _btnAnimationController = OneShotAnimation(
      "active",
      autoplay: false,
    );

    // Espera 3 segundos antes de mostrar el botón
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showButton = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animación de Rive que cubre toda la pantalla
          Positioned.fill(
            child: RiveAnimation.asset(
              "assets/RiveAssets/starthopepals.riv",
              fit: BoxFit.cover, // Ajusta la animación para cubrir toda la pantalla
            ),
          ),
          // Si ha pasado el tiempo y queremos mostrar el botón
          if (_showButton)
            Positioned(
              bottom: 50, // Ajusta la posición del botón
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedBtn(
                  btnAnimationController: _btnAnimationController,
                  press: () {
                    _btnAnimationController.isActive = true;

                    Future.delayed(
                      const Duration(milliseconds: 800),
                          () {
                        setState(() {
                          isShowSignInDialog = true;
                        });
                        if (!context.mounted) return;
                        showCustomDialog(
                          context,
                          onValue: (_) {},
                        );
                      },
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
