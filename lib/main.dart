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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Transform.translate(
            offset:
                const Offset(0, 10), // Ajusta este valor para bajar el título
            child: const Text('Bola 8'),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Escribe tu pregunta',
                  hintStyle: TextStyle(color: Colors.pink[200]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _enviarPregunta,
                style: ElevatedButton.styleFrom(elevation: 2.0),
                child: const Text('preguntar'),
              ),
              SizedBox(height: 20),
              Text(
                _preguntaActual.isEmpty
                    ? 'Hazme una pregunta'
                    : _preguntaActual,
                style:
                    const TextStyle(fontSize: 18, fontStyle: FontStyle.normal),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: _cambiarRespuesta,
                child: Material(
                  shape: const CircleBorder(),
                  elevation: 15.0,
                  color: Colors.transparent,
                  child: CircleAvatar(
                    radius: 120,
                    backgroundColor: Colors.pink[200],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _respuestaActual,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 22),
                        textAlign: TextAlign.center,
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
  }
}
