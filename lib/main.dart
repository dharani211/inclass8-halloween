// partner name: Shreya Reddy Kowkutla
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math';

void main() {
  runApp(HalloweenApp());
}

class HalloweenApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Halloween Game',
      theme: ThemeData.dark(),
      home: HalloweenGame(),
    );
  }
}

class HalloweenGame extends StatefulWidget {
  @override
  _HalloweenGameState createState() => _HalloweenGameState();
}

class _HalloweenGameState extends State<HalloweenGame> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late List<String> bugs;
  late String correctBug;
  bool gameStarted = false;
  String? resultText;

  @override
  void initState() {
    super.initState();
    bugs = [
      'bug1.png',
      'bug2.png',
      'bug3.png',
      'bug4.png',
      'bug5.png',
      'bug6.png',
    ];
    correctBug = bugs[Random().nextInt(bugs.length)];
  }

  void startGame() {
    _audioPlayer.setSource(AssetSource('spooky.mp3'));
    _audioPlayer.resume();
    setState(() {
      gameStarted = true;
      resultText = null; // Reset result text
    });
  }

  void selectBug(String selectedBug) {
    if (selectedBug == correctBug) {
      _audioPlayer.setSource(AssetSource('success.mp3'));
      _audioPlayer.resume();
      setState(() {
        resultText = 'Congratulations!';
      });
    } else {
      _audioPlayer.setSource(AssetSource('trap.mp3'));
      _audioPlayer.resume();
      setState(() {
        resultText = null; // Hide previous result text
      });
      // Trigger bat animation
      showBat();
    }
  }

  void showBat() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: AnimatedBat(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.black),
          Center(
            child: gameStarted
                ? Stack(
                    children: bugs.map((bug) {
                      return Positioned(
                        left: Random().nextDouble() * 300,
                        top: Random().nextDouble() * 600,
                        child: GestureDetector(
                          onTap: () => selectBug(bug),
                          child: Image.asset('assets/$bug'),
                        ),
                      );
                    }).toList(),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/ghost.png'),
                      ElevatedButton(
                        onPressed: startGame,
                        child: Text('Start Game'),
                      ),
                    ],
                  ),
          ),
          if (resultText != null)
            Center(
              child: Text(
                resultText!,
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
        ],
      ),
    );
  }
}

class AnimatedBat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/bat.png')
        .animate()
        .scale(
          begin: Offset(0.0, 0.0),
          end: Offset(1.5, 1.5),
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
        )
        .then()
        .fadeIn(duration: Duration(seconds: 1))
        .then()
        .fadeOut(duration: Duration(seconds: 1));
  }
}
