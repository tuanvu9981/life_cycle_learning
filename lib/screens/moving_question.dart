import 'package:flutter/material.dart';

class MovingQuestion extends StatefulWidget {
  const MovingQuestion({super.key});

  @override
  MovingQuestionState createState() => MovingQuestionState();
}

class MovingQuestionState extends State<MovingQuestion> {
  Widget _buildQuestionBox(Size size) {
    ValueNotifier<bool> isTap = ValueNotifier(false);
    return Container(
      margin: const EdgeInsets.all(2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/koduck.png', width: 120, height: 180),
          const SizedBox(width: 15.0),
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7.5),
              border: Border.all(color: Colors.blue.shade300, width: 0.5),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ValueListenableBuilder(
                    valueListenable: isTap,
                    builder: (context, value, child) {
                      return GestureDetector(
                        onTap: () {
                          isTap.value = !isTap.value;
                        },
                        child: Icon(
                            isTap.value
                                ? Icons.volume_up_outlined
                                : Icons.volume_down_outlined,
                            color: Colors.blue.shade300,
                            size: 40.0),
                      );
                    },
                  ),
                  const Text("ラーメンを食べる", style: TextStyle(fontSize: 20.0))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSelectedArea(Size size) {
    return Container();
  }

  Widget _buildMovingItemBox(Size size) {
    return Container();
  }

  Widget _buildConfirmButton(Size size) {
    return GestureDetector(
      onTap: () {},
      child: Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildQuestionBox(size),
              _buildSelectedArea(size),
              _buildMovingItemBox(size),
              _buildConfirmButton(size)
            ],
          ),
        ),
      ),
    );
  }
}
