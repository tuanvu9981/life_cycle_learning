import 'package:flutter/animation.dart';

class MovingItem {
  String? word;
  bool isSelected;
  Animation<Offset>? offsetAnimation;
  int? index;
  MovingCoordinates newPosition;

  MovingItem(
    this.word,
    this.isSelected,
    this.offsetAnimation,
    this.index,
    this.newPosition,
  );
}

class MovingCoordinates {
  double newUp;
  double newDown;
  double newLeft;
  double newRight;

  MovingCoordinates(this.newUp, this.newDown, this.newLeft, this.newRight);
}
