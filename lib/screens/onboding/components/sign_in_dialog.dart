import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hopepals_game/screens/entryPoint/entry_point.dart';
import 'package:hopepals_game/screens/home/VoiceTest.dart';
import 'package:hopepals_game/screens/home/home_screen.dart'; // Asegúrate de que esta importación sea correcta
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hopepals_game/main.dart';
import 'package:hopepals_game/screens/onboding/components/sign_in_form.dart';

void showCustomDialog(BuildContext context, {required ValueChanged onValue}) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Container(
          height: 670,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.90),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 30),
                blurRadius: 60,
              ),
              const BoxShadow(
                color: Colors.black45,
                offset: Offset(0, 30),
                blurRadius: 60,
              ),
            ],
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              clipBehavior: Clip.none,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        "Sign in",
                        style: TextStyle(
                          fontSize: 34,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          "Inicia sesión para tener todas las funcionalidades de tu asistente.",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SignInForm(),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center, // Alineación central
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 1, // Grosor de la línea
                              color: Colors.black26, // Color de la línea
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "OR",
                              style: TextStyle(
                                color: Colors.black26,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 1, // Grosor de la línea
                              color: Colors.black26, // Color de la línea
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    try {
                                      final GoogleSignIn googleSignIn =
                                      GoogleSignIn();
                                      final GoogleSignInAccount? googleUser =
                                      await googleSignIn.signIn();

                                      if (googleUser == null) return;

                                      final GoogleSignInAuthentication
                                      googleAuth =
                                      await googleUser.authentication;

                                      final response = await Supabase.instance
                                          .client.auth
                                          .signInWithOAuth(
                                        OAuthProvider.google,
                                      );

                                      final user = Supabase.instance.client.auth.currentUser;

                                      if (user != null) {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                                HomePage(),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              final scaleAnimation =
                                              Tween<double>(
                                                  begin: 0.95, end: 1.0)
                                                  .animate(
                                                CurvedAnimation(
                                                  parent: animation,
                                                  curve: Curves.easeInOut,
                                                ),
                                              );
                                              final fadeAnimation =
                                              Tween<double>(
                                                  begin: 0.0, end: 1.0)
                                                  .animate(
                                                CurvedAnimation(
                                                  parent: animation,
                                                  curve: Curves.easeInOut,
                                                ),
                                              );
                                              return FadeTransition(
                                                opacity: fadeAnimation,
                                                child: ScaleTransition(
                                                  scale: scaleAnimation,
                                                  child: child,
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      } else {
                                        print(
                                            "Error: No se pudo autenticar al usuario");
                                      }
                                    } catch (e) {
                                      print("Error al iniciar sesión con Google: $e");
                                    }
                                  },
                                  padding: EdgeInsets.zero,
                                  icon: SvgPicture.asset(
                                    "assets/icons/google_icon.svg",
                                    height: 64,
                                    width: 64,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16), // Espacio entre el icono y el texto
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => EntryPoint(),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      final scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
                                        CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.easeInOut,
                                        ),
                                      );
                                      final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
                                        CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.easeInOut,
                                        ),
                                      );

                                      return FadeTransition(
                                        opacity: fadeAnimation,
                                        child: ScaleTransition(
                                          scale: scaleAnimation,
                                          child: child,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                              child: const Text(
                                "Continuar sin conexión",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      final tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
      return SlideTransition(
        position: tween.animate(
          CurvedAnimation(parent: anim, curve: Curves.easeInOut),
        ),
        child: child,
      );
    },
  ).then(onValue);
}
