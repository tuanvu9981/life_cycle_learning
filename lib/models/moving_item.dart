import 'package:flutter/animation.dart';

class MovingItem {
  String? word;
  bool? isSelected;
  Animation<Offset>? offsetAnimation;

  MovingItem(this.word, this.isSelected, this.offsetAnimation);
}
