import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'Basket.dart';
import 'FruitMergeGame.dart';

enum FruitType { orange, apple, pineapple }

class Fruit extends SpriteComponent with CollisionCallbacks {
  final FruitType type;
  Vector2 velocity = Vector2(0, 0); // Inicialmente sin gravedad
  bool isDragging = true; // Para controlar si el usuario está moviendo la fruta
  final Basket basket; // Referencia a la canasta

  // Establece si la fruta debe comenzar a caer
  bool shouldFall = false; // Controla si la fruta debe caer o no

  void startFalling() {
    // Reinicia la velocidad para que la fruta caiga
    velocity.y = 0; // Reinicia la velocidad en Y
    shouldFall = true; // Permitir que la fruta caiga
  }

  Fruit({required this.type, required Vector2 position, required this.basket})
      : super(position: position, size: Vector2(50, 50));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await Sprite.load(getSpriteForType(type));
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Solo aplica gravedad si no está arrastrando y debería caer
    if (shouldFall) {
      velocity.y += 10 * dt; // Gravedad
      if (velocity.y > 200) { // Velocidad máxima
        velocity.y = 200;
      }
      position += velocity * dt;

      // Ajustar la posición en relación con la canasta
      if (position.y + size.y > basket.position.y) {
        position.y = basket.position.y - size.y; // Coloca la fruta justo en la parte superior de la canasta
        velocity.y = 0; // Detener la fruta cuando llega a la canasta
      }
    }
  }

  // Obtener la ruta del sprite según el tipo de fruta
  String getSpriteForType(FruitType type) {
    switch (type) {
      case FruitType.orange:
        return 'FruitMerge/Orange.png';
      case FruitType.apple:
        return 'FruitMerge/Apple.png';
      case FruitType.pineapple:
        return 'FruitMerge/Pineapple.png';
      default:
        return ''; // Manejar el caso por defecto
    }
  }
}
