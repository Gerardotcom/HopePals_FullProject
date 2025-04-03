import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:collection/collection.dart'; // Para firstWhereOrNull
import 'package:flutter/gestures.dart';
import 'Basket.dart';
import 'FruitType.dart';

class FruitMergeGame extends FlameGame with TapDetector {
  late Basket basket;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Inicializa la canasta
    basket = Basket(size.x, size.y * 0.75);
    add(basket);
    // Añadir fruta arrastrable
    add(Fruit(type: FruitType.orange, position: Vector2(100, 100), basket: basket)); // Pasar la canasta
  }

  @override
  void TapDownDetails(PointerDownEvent event) {
    // Imprimir la posición donde se tocó la pantalla
    print('Pantalla tocada'); // Mensaje de prueba
    print('Posición del toque: ${event.localPosition}'); // Imprime la posición del toque
  }

  @override
  void onPointerMove(PointerMoveEvent event) {
    // Puedes agregar código aquí si deseas manejar el movimiento
  }

  @override
  void TapUpDetails(PointerUpEvent event) {
    // Puedes agregar código aquí si deseas manejar el levantamiento del toque
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Aquí puedes actualizar otros componentes si es necesario
  }
}
