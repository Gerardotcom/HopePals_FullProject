import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart'; // Import necesario para rootBundle

class PetStates extends StatefulWidget {
  @override
  _PetStatesScreenState createState() => _PetStatesScreenState();
}

class _PetStatesScreenState extends State<PetStates> {
  StateMachineController? _stateMachineController;

  @override
  void initState() {
    super.initState();
    _loadRiveStateMachine();
  }

  // Método para cargar la máquina de estados
  void _loadRiveStateMachine() async {
    final bytes = await rootBundle.load('assets/RiveAssets/petstatesAnim.riv');
    final file = RiveFile.import(bytes);

    // Obtener el mainArtboard y el controlador de la máquina de estados
    final artboard = file.mainArtboard;
    _stateMachineController = StateMachineController.fromArtboard(
      artboard,
      'PetState', // Reemplaza 'StateMachine' con el nombre exacto de tu State Machine
    );

    if (_stateMachineController != null) {
      artboard.addController(_stateMachineController!);
      setState(() {}); // Actualizar el estado una vez que el controlador esté configurado
    }
  }

  // Método para activar un trigger en la máquina de estados
  void _triggerJumpAnimation() {
    // Acceder al input 'JumpClick' en la State Machine
    final trigger = _stateMachineController?.findInput<bool>('TalkClick');
    if (trigger != null) {
      trigger.value = true; // Activar el trigger
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rive Animation'),
      ),
      body: Center(
        child: RiveAnimation.asset(
          'assets/RiveAssets/petstatesAnim.riv',
          fit: BoxFit.contain,
          onInit: (artboard) {
            // Agregar el controlador cuando se inicializa la animación
            _stateMachineController ??= StateMachineController.fromArtboard(
              artboard,
              'StateMachine',
            );
            if (_stateMachineController != null) {
              artboard.addController(_stateMachineController!);
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _triggerJumpAnimation, // Llamada al trigger
        child: Icon(Icons.directions_run),
      ),
    );
  }
}
