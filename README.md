## Illustrate about didChangeDependencies and didWidgetUpdated

### About Flutter Life Cycle.

### Example to illustrate didChangeDependencies.

### Example to illustrate didWidgetUpdated.

### Roadmap
- [x] Touching chip containing word upwards vertically. 
- [x] Touching upwards chip above will make it return to the beginning place vertically. 
- [ ] Touching chip when considering orders 
    - [ ] The first chip touched will move to the top-left place. 
    - [ ] The last chip touched will move the bottom-right place. 
    - [ ] The last item in the line will jump into the next line if there isnt enough space. 
- [ ] Touching upwards chip above will make it return and make the next item to it closer 
    - [ ] The item at the next line will turn into the previous line.

### Example about MovingQuestion in Duolinguo
1. Get position by Key
   - References: [StackOverflow](https://stackoverflow.com/questions/62029541/how-to-get-the-position-of-a-widget-in-the-screen-preferably-in-offset)
   - printed out result: **Rect.fromLTRB(211.5, 590.7, 313.5, 648.7)**

2. Get size, co-ordinates x and y (top left) of flutter widget
   - References: [Flutter campus URL](https://www.fluttercampus.com/guide/124/how-to-get-height-and-width-of-widget-on-flutter/)
   - Coordinates of widgets will be TOP - LEFT   
