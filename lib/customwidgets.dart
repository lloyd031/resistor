import 'package:flutter/material.dart';

import 'Component.dart';


class DraggableButton extends StatefulWidget {
  String? imgicon;
  DraggableButton(this.imgicon);

  @override
  State<DraggableButton> createState() => _DraggableButtonState();
}

class _DraggableButtonState extends State<DraggableButton> {
  @override
  Widget build(BuildContext context) {
    return Draggable<Component>(
                    data: Component("${widget.imgicon}"),
                    feedback:  SizedBox(
                    width: 60,
                    height: 60,
                    child:Center(child:
                    Image.asset('imgs/${widget.imgicon}.png',
                    fit: BoxFit.cover,
                    width: 1000,
                    )),
                  ),
                    childWhenDragging:Text("${widget.imgicon}", style: const TextStyle(color:Colors.yellow),) ,
                    child:  Text("${widget.imgicon}", style: const TextStyle(color:Colors.white),),);
  }
}