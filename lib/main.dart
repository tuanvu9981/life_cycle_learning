import 'package:flutter/material.dart';
import 'package:life_cycle_learning/screens/moving_question.dart';

void main() {
  runApp(const LifeCycleDragApp());
}

class LifeCycleDragApp extends StatelessWidget {
  const LifeCycleDragApp({super.key});

  @override
  Widget build(BuildContext context) {
    final texts = ["I", "ramen", "noodles", "eat", "favourite", "mine", "My"];
    const trueAnswer = "I eat ramen";

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MovingQuestion(texts: texts, trueAnswer: trueAnswer),
    );
  }
}
