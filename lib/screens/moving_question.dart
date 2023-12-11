import 'package:flutter/material.dart';

class MovingQuestion extends StatefulWidget {
  const MovingQuestion({super.key});

  @override
  MovingQuestionState createState() => MovingQuestionState();
}

class MovingQuestionState extends State<MovingQuestion> {
  List<String> answers = [
    "I",
    "ramen",
    "noodles",
    "eat",
    "favourite",
    "mine",
    "My"
  ];
  String trueAnswer = "I eat ramen";
  List<String> selectedItems = [];

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
      child: Wrap(
        alignment: WrapAlignment.start,
        children: selectedItems
            .map<Widget>((e) => Container(
                  margin: const EdgeInsets.all(5.0),
                  child: ActionChip(
                    onPressed: () {
                      setState(() {
                        answers.add(e);
                        selectedItems.remove(e);
                      });
                    },
                    label: Text(e, style: const TextStyle(fontSize: 16.0)),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildMovingItemBox() {
    return Container(
      margin: const EdgeInsets.all(5.0),
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          children: answers.map<Widget>((e) {
            final key = GlobalKey(debugLabel: e);
            return Container(
              key: key,
              margin: const EdgeInsets.all(5.0),
              child: ActionChip(
                onPressed: () {
                  final renderObject = key.currentContext?.findRenderObject();
                  final translation =
                      renderObject?.getTransformTo(null).getTranslation();
                  if (translation != null &&
                      renderObject?.paintBounds != null) {
                    final offset = Offset(translation.x, translation.y);
                    print(renderObject!.paintBounds.shift(offset));
                  }
                  setState(() {
                    selectedItems.add(e);
                    answers.remove(e);
                  });
                },
                label: Text(e, style: const TextStyle(fontSize: 16.0)),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildConfirmButton(Size size, BuildContext context) {
    return GestureDetector(
      onTap: () {
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
      },
      child: Container(
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: selectedItems.isEmpty ? Colors.grey.shade400 : Colors.green,
        ),
        child: Center(
          child: Text(
            "Confirm",
            style: TextStyle(
              fontSize: 16.0,
              color: selectedItems.isEmpty ? Colors.black : Colors.white,
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
                  child: _buildConfirmButton(size, context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
