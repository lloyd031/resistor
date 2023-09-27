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
                    width: 53,
                    height: 53,
                    child:Center(child:
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                                  width:11,
                                  height:11,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(11),
                                    color:Colors.white,
                                    border: Border.all(color: const Color.fromRGBO(1, 48, 63, 1), width: 2.5)
                                    
                                  ),
                                  
                                ),
                        Expanded(
                          child: Image.asset('imgs/${widget.imgicon}.png',
                          fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                                  width:11,
                                  height:11,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(11),
                                    color:Colors.white,
                                    border: Border.all(color: const Color.fromRGBO(1, 48, 63, 1), width: 2.5)
                                    
                                  ),
                                  
                                ),
                      ],
                    )),
                  ),
                    childWhenDragging:Text("${widget.imgicon}", style: const TextStyle(color:Colors.yellow),) ,
                    child:  Text("${widget.imgicon}", style: const TextStyle(color:Colors.white),),);
  }
}