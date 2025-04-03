import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'FruitType.dart';


class Basket extends PositionComponent with CollisionCallbacks {
  Basket(double width, double height)
      : super(size: Vector2(width * 0.85 , height * 0.75), position: Vector2(width * 0.075, height * 0.55)); // Ajusta la posición

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Añadir un hitbox rectangular a la canasta (sin el borde superior)
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Dibuja los bordes de la canasta (sin el borde superior)
    final paint = Paint()
      ..color = Colors.white // Color blanco para el borde
      ..style = PaintingStyle.stroke // Solo borde, sin relleno
      ..strokeWidth = 10; // Grosor del borde

    // Dibujamos solo los bordes izquierdo, derecho e inferior
    final left = Offset(0, 0); // Esquina superior izquierda
    final right = Offset(size.x, 0); // Esquina superior derecha
    final bottomLeft = Offset(0, size.y); // Esquina inferior izquierda
    final bottomRight = Offset(size.x, size.y); // Esquina inferior derecha

    // Borde izquierdo
    canvas.drawLine(left, bottomLeft, paint);

    // Borde derecho
    canvas.drawLine(right, bottomRight, paint);

    // Borde inferior
    canvas.drawLine(bottomLeft, bottomRight, paint);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Fruit) {
      // Lógica de combinación de frutas o detener el movimiento
    }
  }

}