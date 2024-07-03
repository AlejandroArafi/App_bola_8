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
  final TextEditingController _controller = TextEditingController();
  String _preguntaActual = "";

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

  void _enviarPregunta() {
    setState(() {
      _preguntaActual = _controller.text;
      _controller.clear();
      _cambiarRespuesta();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bola 8'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Escribe tu pregunta',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _enviarPregunta,
                child: Text('preguntar'),
              ),
              SizedBox(height: 20),
              Text(
                _preguntaActual.isEmpty
                    ? 'hazme una pregunta'
                    : _preguntaActual,
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: _cambiarRespuesta,
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _respuestaActual,
                      style: const TextStyle(color: Colors.white, fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
