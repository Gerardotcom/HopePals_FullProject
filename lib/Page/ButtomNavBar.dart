import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hopepals_game/utils/rive_utils.dart';
import 'package:rive/rive.dart';
import '../../model/menu.dart';
import 'package:hopepals_game/constants.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({
    Key? key,
    required this.currentIndex,
    required this.onItemSelected,
  }) : super(key: key);

  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  @override
  _BottomNavigationBarWidgetState createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  Menu? selectedBottonNav;

  @override
  void initState() {
    super.initState();
    selectedBottonNav = bottomNavItems[widget.currentIndex];
  }

  void updateSelectedBtmNav(Menu navBar, int index) {
    setState(() {
      selectedBottonNav = navBar;
    });
    widget.onItemSelected(index); // Llama al callback para manejar el cambio de pantalla
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(45),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            decoration: BoxDecoration(
              color: backgroundColor2.withOpacity(0.5),
              borderRadius: const BorderRadius.all(
                Radius.circular(45),
              ),
              boxShadow: [
                BoxShadow(
                  color: backgroundColor2.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...List.generate(bottomNavItems.length, (index) {
                  Menu navBar = bottomNavItems[index];
                  return GestureDetector(
                    onTap: () {
                      RiveUtils.chnageSMIBoolState(navBar.rive.status!);
                      updateSelectedBtmNav(navBar, index);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 36,
                          width: 36,
                          child: Opacity(
                            opacity: selectedBottonNav == navBar ? 1 : 0.5,
                            child: RiveAnimation.asset(
                              navBar.rive.src,
                              artboard: navBar.rive.artboard,
                              onInit: (artboard) {
                                navBar.rive.setStatus = RiveUtils.getRiveInput(
                                  artboard,
                                  stateMachineName: navBar.rive.stateMachineName,
                                );
                              },
                            ),
                          ),
                        ),
                        if (selectedBottonNav == navBar)
                          Container(
                            margin: const EdgeInsets.only(top: 0),
                            width: 14,
                            height: 4,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(Radius.circular(2)),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
