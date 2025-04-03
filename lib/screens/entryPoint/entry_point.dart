import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hopepals_game/screens/TaskListScreen.dart';
import 'package:hopepals_game/screens/chatScreen.dart';
import 'package:hopepals_game/screens/profileScreen.dart';
import 'package:hopepals_game/screens/home/VoiceTest.dart';
import 'package:hopepals_game/screens/home/home_screen.dart';

import 'package:hopepals_game/constants.dart';
import 'package:rive/rive.dart';
import 'package:hopepals_game/utils/rive_utils.dart';
import '../../model/menu.dart';
import 'components/btm_nav_item.dart';
import 'components/menu_btn.dart';
import 'components/side_bar.dart';
import 'package:hopepals_game/Page/ButtomNavBar.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint>
    with SingleTickerProviderStateMixin {
  bool isSideBarOpen = false;

  late AnimationController _animationController;
  late Animation<double> scalAnimation;
  late Animation<double> animation;

  // Controla la pantalla actual que se muestra
  int currentIndex = 0;

  // Lista de pantallas
  final List<Widget> screens = [
    TaskListScreen(),
    ChatScreen(),
    VoiceAssistant(),
    HomePage(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(() {
        setState(() {});
      });
    scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn),
    );
    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent, // Fondo transparente para mostrar el Rive
      body: Stack(
        children: [
          // Fondo animado Rive
          const RiveAnimation.asset(
            'assets/Backgrounds/backgroundScreens_v1.riv', // Ruta de tu archivo Rive
            fit: BoxFit.cover,
          ),
          // Sidebar
          AnimatedPositioned(
            width: 288,
            height: MediaQuery.of(context).size.height,
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            left: isSideBarOpen ? 0 : -288,
            top: 0,
            child: const SideBar(),
          ),
          // Main content
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(1 * animation.value - 30 * (animation.value) * pi / 180),
            child: Transform.translate(
              offset: Offset(animation.value * 265, 0),
              child: Transform.scale(
                scale: scalAnimation.value,
                child: screens[currentIndex], // Pantalla actual
              ),
            ),
          ),
          // Menu button
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            left: isSideBarOpen ? 220 : 0,
            top: 16,
            child: MenuBtn(
              press: () {
                if (_animationController.value == 0) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }

                setState(() {
                  isSideBarOpen = !isSideBarOpen;
                });
              },
              riveOnInit: (artboard) {
                final navBar = bottomNavItems[currentIndex];
                navBar.rive.status = RiveUtils.getRiveInput(
                  artboard,
                  stateMachineName: navBar.rive.stateMachineName,
                );
              },
            ),
          ),
        ],
      ),
      // Navbar integrada
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: currentIndex,
        onItemSelected: (index) {
          setState(() {
            currentIndex = index; // Actualiza el índice para cambiar la pantalla
          });
        },
      ),
    );
  }
}
