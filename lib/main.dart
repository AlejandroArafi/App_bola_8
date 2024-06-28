import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final List<String> _respuestas = [
    "Sí",
    "No",
    "Tal vez",
    "Definitivamente",
    "Pregunta de nuevo más tarde",
  ];
  String _respuestaActual = "Hazme una pregunta";
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
      if (event.x.abs() > 15 || event.y.abs() > 15 || event.z.abs() > 15) {
        _cambiarRespuesta();
      }
    });
  }

  void _cambiarRespuesta() {
    setState(() {
      _respuestaActual = _respuestas[Random().nextInt(_respuestas.length)];
    });
    _audioPlayer.play(AssetSource('audio/magic_sound.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: InkWell(
            onTap: _cambiarRespuesta,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.black,
              child: Text(
                _respuestaActual,
                style: const TextStyle(color: Colors.white, fontSize: 22),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
