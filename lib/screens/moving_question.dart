import 'package:flutter/material.dart';
import 'package:life_cycle_learning/models/moving_item.dart';

class MovingQuestion extends StatefulWidget {
  final List<String> texts;
  final String trueAnswer;
  const MovingQuestion({
    super.key,
    required this.texts,
    required this.trueAnswer,
  });

  @override
  MovingQuestionState createState() => MovingQuestionState();
}

class MovingQuestionState extends State<MovingQuestion>
    with TickerProviderStateMixin {
  final double movingOffsetY = 5;
  final double movingOffsetX = 0;

  late List<GlobalKey> keys;
  late List<AnimationController> _controllers;
  late List<MovingItem> answers;
  List<String> currentAnswer = [];

  @override
  void dispose() {
    _controllers.map((e) => e.dispose());
    super.dispose();
  }

  @override
  void initState() {
    keys = [for (int i = 0; i < widget.texts.length; i++) GlobalKey()];

    _controllers = [
      for (int i = 0; i < widget.texts.length; i++)
        AnimationController(
          duration: const Duration(milliseconds: 250),
          vsync: this,
        ),
    ];

    answers = <MovingItem>[
      for (int i = 0; i < _controllers.length; i++)
        MovingItem(
          widget.texts[i],
          false,
          Tween<Offset>(begin: Offset.zero, end: Offset.zero)
              .animate(_controllers[0]),
          i,
          MovingCoordinates(0.0, 0.0, 0.0, 0.0),
        )
    ];

    super.initState();
  }

  MovingCoordinates getNewCoordinates(GlobalKey widgetKey) {
    final renderBox = widgetKey.currentContext?.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    print("offset (dx-left: ${offset.dx} dy-top: ${offset.dy})");
    print("width: ${size.width}, height: ${size.height}");
    return MovingCoordinates(
      offset.dy - size.height * movingOffsetY,
      offset.dy - size.height * (movingOffsetY - 1),
      offset.dx,
      offset.dx + size.width,
    );
  }

  bool isTouchedPointInAnswerWidget(
    Offset touchedPoint,
    MovingCoordinates answerWidget,
  ) {
    double dy = touchedPoint.dy;
    double dx = touchedPoint.dx;

    bool isDyBetween = dy <= answerWidget.newDown && dy >= answerWidget.newUp;
    bool isDxBetween =
        dx <= answerWidget.newRight && dx >= answerWidget.newLeft;

    return isDyBetween && isDxBetween;
  }

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
            height: size.height * 0.1,
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 35.0),
    );
  }

  Widget _buildMovingItemBox() {
    return Container(
      margin: const EdgeInsets.all(5.0),
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          children: answers
              .map<Widget>((e) => Container(
                    margin: const EdgeInsets.all(5.0),
                    child: Stack(
                      children: [
                        Chip(
                          label: Text(
                            e.word!,
                            style: TextStyle(color: Colors.grey.shade400),
                          ),
                          backgroundColor: Colors.grey.shade400,
                        ),
                        SlideTransition(
                          position: e.offsetAnimation!,
                          child: ActionChip(
                            key: keys[e.index!],
                            onPressed: () {
                              setState(() {
                                answers = answers
                                    .map((item) {
                                      if (item.word == e.word) {
                                        currentAnswer.add(item.word!);
                                        item.isSelected = true;
                                        item.newPosition =
                                            getNewCoordinates(keys[e.index!]);
                                        item.offsetAnimation = Tween<Offset>(
                                          begin: Offset.zero,
                                          end: Offset(
                                              movingOffsetX, -movingOffsetY),
                                        ).animate(_controllers[e.index!]);
                                      }
                                      return item;
                                    })
                                    .cast<MovingItem>()
                                    .toList();
                              });
                              _controllers[e.index!].reset();
                              _controllers[e.index!].forward();
                            },
                            label: Text(
                              e.word!,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                        )
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildConfirmButton(Size size, BuildContext context, int counter) {
    return GestureDetector(
      onTap: () {
        print("currentAnswer: $currentAnswer");
        final compared =
            currentAnswer.join(" ").trim().compareTo(widget.trueAnswer);
        if (compared == 0) {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  height: size.height * 0.2,
                  color: Colors.lightGreen.shade300,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Congratulations!",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.5,
                          ),
                        ),
                        const SizedBox(height: 12.5),
                        GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 20.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: const Text(
                              "Continue",
                              style: TextStyle(
                                color: Colors.lightGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.5,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
        }
      },
      child: Container(
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: counter == 0 ? Colors.grey.shade400 : Colors.green,
        ),
        child: Center(
          child: Text(
            "Confirm",
            style: TextStyle(
              fontSize: 16.0,
              color: counter == 0 ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    int counter = currentAnswer.length;
    // heigh: 841.85 - width: 400
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade200,
        title: const Center(
          child: Text(
            "Lesson 1: Basic grammars",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTapDown: (details) {
            final tapPosition = details.globalPosition;
            print("dx: ${tapPosition.dx}, dy: ${tapPosition.dy}\n\n");

            for (int i = 0; i < _controllers.length; i++) {
              if (answers[i].isSelected) {
                print("text selected: ${answers[i].word}");
                final checkBetween = isTouchedPointInAnswerWidget(
                  tapPosition,
                  answers[i].newPosition,
                );
                if (checkBetween) {
                  _controllers[i].reverse();
                  setState(() {
                    answers = answers
                        .map((item) {
                          if (item.word == answers[i].word) {
                            item.isSelected = false;
                            currentAnswer.removeWhere((e) => e == item.word);
                          }
                          return item;
                        })
                        .cast<MovingItem>()
                        .toList();
                  });
                }
              }
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(15.0),
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: size.height * 0.8,
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildQuestionBox(size),
                  ),
                  Expanded(
                    flex: 3,
                    child: _buildSelectedArea(size),
                  ),
                  Expanded(
                    flex: 3,
                    child: _buildMovingItemBox(),
                  ),
                  Expanded(
                    flex: 1,
                    child: _buildConfirmButton(size, context, counter),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
