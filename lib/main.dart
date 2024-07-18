import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
      onGenerateRoute: (settings) {
        if (settings.name == '/respuesta') {
          final String pregunta = settings.arguments as String;
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                RespuestaScreen(pregunta: pregunta),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          );
        }
        return null;
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _respuestas = [
    "Sí",
    "No",
    "Tal vez",
    "Definitivamente",
    "No lo sé",
    "Pregunta de nuevo",
  ];
  String _preguntaActual = "";
  final AudioPlayer _audioPlayer = AudioPlayer();
  final TextEditingController _controller = TextEditingController();

  void _enviarPregunta() {
    setState(() {
      _preguntaActual = _controller.text;
      _controller.clear();
    });

    Navigator.pushNamed(
      context,
      '/respuesta',
      arguments: _preguntaActual,
    ).then((_) {
      _audioPlayer.play(AssetSource('audio/achievement-sparkle.wav'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Transform.translate(
          offset: const Offset(0, 10),
          child: Text(
            'App Bola 8',
            style: GoogleFonts.ubuntu(),
          ),
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
                    color: Color.fromARGB(255, 225, 61, 240),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _enviarPregunta,
              style: ElevatedButton.styleFrom(elevation: 2.0),
              child: const Text('preguntar'),
            ),
            const SizedBox(height: 20),
            Text(
              _preguntaActual.isEmpty ? 'Hazme una pregunta' : _preguntaActual,
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.normal),
            ),
          ],
        ),
      ),
    );
  }
}

class RespuestaScreen extends StatefulWidget {
  final String pregunta;

  const RespuestaScreen({required this.pregunta, Key? key}) : super(key: key);

  @override
  _RespuestaScreenState createState() => _RespuestaScreenState();
}

class _RespuestaScreenState extends State<RespuestaScreen>
    with SingleTickerProviderStateMixin {
  final List<String> _respuestas = [
    "Sí",
    "No",
    "Tal vez",
    "Definitivamente",
    "No lo sé",
    "Pregunta de nuevo",
  ];
  String _respuestaActual = "";
  final AudioPlayer _audioPlayer = AudioPlayer();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _respuestaActual = _respuestas[Random().nextInt(_respuestas.length)];
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation =
        Tween<double>(begin: 0, end: 2 * pi).animate(_animationController)
          ..addListener(() {
            setState(() {});
          });
    _animationController.forward(from: 0);

    SensorsPlatform.instance.accelerometerEvents
        .listen((AccelerometerEvent event) {
      if (event.x.abs() > 15 || event.y.abs() > 15 || event.z.abs() > 15) {
        _cambiarRespuesta();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _cambiarRespuesta() {
    setState(() {
      _respuestaActual = _respuestas[Random().nextInt(_respuestas.length)];
    });
    _audioPlayer.play(AssetSource('audio/achievement-sparkle.wav'));
    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Respuesta'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Pregunta: ${widget.pregunta}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _cambiarRespuesta,
              child: Transform.rotate(
                angle: _animation.value,
                child: Material(
                  shape: const CircleBorder(),
                  elevation: 15.0,
                  color: Colors.transparent,
                  child: CircleAvatar(
                    radius: 130,
                    backgroundColor: Colors.pink[200],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _respuestaActual,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
