import 'dart:ui'; // Importa esta librería para usar ImageFilter
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:hopepals_game/Page/ButtomNavBar.dart';
import 'package:hopepals_game/screens/home/home_screen.dart';

class FlappyBirdApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flappy Bird',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static double birdYAxis = 0;
  double time = 0;
  double height = 0;
  double initialHeight = birdYAxis;
  bool gameHasStarted = false;
  static double barrierXOne = 1;
  double barrierXTwo = barrierXOne + 1.5;
  int score = 0;
  bool gameOver = false;

  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdYAxis;
    });
  }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      time += 0.04;
      height = -4.9 * time * time + 2.8 * time;
      setState(() {
        birdYAxis = initialHeight - height;

        // Mover barreras
        barrierXOne -= 0.05;
        barrierXTwo -= 0.05;

        // Reiniciar posición de barreras
        if (barrierXOne < -2) {
          barrierXOne += 3.5;
          score++;
        }
        if (barrierXTwo < -2) {
          barrierXTwo += 3.5;
          score++;
        }

        // Verificar colisión con el suelo
        if (birdYAxis > 1) {
          timer.cancel();
          gameHasStarted = false;
          gameOver = true;
        }

        // Verificar colisión con barreras
        if (barrierXOne < 0.2 && barrierXOne > -0.2) {
          if (birdYAxis < -0.3 || birdYAxis > 0.3) {
            timer.cancel();
            gameHasStarted = false;
            gameOver = true;
          }
        }

        if (barrierXTwo < 0.2 && barrierXTwo > -0.2) {
          if (birdYAxis < -0.3 || birdYAxis > 0.3) {
            timer.cancel();
            gameHasStarted = false;
            gameOver = true;
          }
        }
      });
    });
  }

  void resetGame() {
    setState(() {
      birdYAxis = 0;
      gameHasStarted = false;
      time = 0;
      initialHeight = birdYAxis;
      barrierXOne = 1;
      barrierXTwo = barrierXOne + 1.5;
      score = 0;
      gameOver = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameHasStarted) {
          jump();
        } else if (gameOver) {
          resetGame();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true, // Extiende el cuerpo detrás del AppBar
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60), // Altura del AppBar
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AppBar(
                backgroundColor: Colors.white.withOpacity(0.3),
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.pause_circle_filled_rounded, color: Colors.white),
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  ),
                ),
                title: Text(
                  "Flappy Bird",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Stack(
                    children: [
                      AnimatedContainer(
                        alignment: Alignment(0, birdYAxis),
                        duration: Duration(milliseconds: 0),
                        color: Colors.blue,
                        child: Bird(),
                      ),
                      Container(
                        alignment: Alignment(barrierXOne, 1.1),
                        child: Barrier(size: 200.0),
                      ),
                      Container(
                        alignment: Alignment(barrierXOne, -1.1),
                        child: Barrier(size: 200.0),
                      ),
                      Container(
                        alignment: Alignment(barrierXTwo, 1.1),
                        child: Barrier(size: 150.0),
                      ),
                      Container(
                        alignment: Alignment(barrierXTwo, -1.1),
                        child: Barrier(size: 250.0),
                      ),
                      Container(
                        alignment: Alignment(0, -0.3),
                        child: gameOver
                            ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Game Over",
                              style: TextStyle(
                                  fontSize: 30, color: Colors.white),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Presiona para reiniciar",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                          ],
                        )
                            : Text(''),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 15,
                  color: Colors.green,
                ),
                Expanded(
                  child: Container(
                    color: Colors.brown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'SCORE',
                              style:
                              TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            SizedBox(height: 20),
                            Text(
                              '$score',
                              style:
                              TextStyle(color: Colors.white, fontSize: 35),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'BEST',
                              style:
                              TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            SizedBox(height: 20),
                            Text(
                              '10',
                              style:
                              TextStyle(color: Colors.white, fontSize: 35),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Bird extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      child: Image.network(
        'https://raw.githubusercontent.com/sourabhv/FlapPyBird/master/assets/sprites/yellowbird-midflap.png',
      ),
    );
  }
}

class Barrier extends StatelessWidget {
  final size;

  Barrier({this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: size,
      decoration: BoxDecoration(
        color: Colors.green,
        border: Border.all(width: 10, color: Colors.green.shade800),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
