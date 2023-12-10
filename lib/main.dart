import 'package:flutter/material.dart';
import 'package:life_cycle_learning/screens/moving_question.dart';

void main() {
  runApp(const LifeCycleDragApp());
}

class LifeCycleDragApp extends StatelessWidget {
  const LifeCycleDragApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MovingQuestion(),
    );
  }
}
