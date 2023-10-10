import 'package:flutter/material.dart';

import 'Component.dart';
import 'DragTargetComp.dart';


class DraggableButton extends StatefulWidget {
  String? imgicon;
  DraggableButton(this.imgicon);

  @override
  State<DraggableButton> createState() => _DraggableButtonState();
}

class _DraggableButtonState extends State<DraggableButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Draggable<Component>(
                      data: Component("${widget.imgicon}"),
                      feedback: (widget.imgicon=="ground")?Transform.rotate(
                        angle: -90*0.0174533,
                        child: GroundModel(comp: null, tail: null,),
                      ): SizedBox(
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
                                      color:const Color.fromRGBO(35,35, 35, 1),
                                      border: Border.all(color: const Color.fromRGBO(169, 169, 169, 1), width: 2.5)
                                      
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
                                      color:const Color.fromRGBO(35,35, 35, 1),
                                      border: Border.all(color: const Color.fromRGBO(169, 169, 169, 1), width: 2.5)
                                      
                                    ),
                                    
                                  ),
                        ],
                      )),
                    ),
                      childWhenDragging:Text("${widget.imgicon}", style: const TextStyle(color:Colors.yellow),) ,
                      child:  Text("${widget.imgicon}", style: const TextStyle(color:Colors.white),),),
    );
  }
}