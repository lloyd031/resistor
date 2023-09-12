import 'package:flutter/material.dart';

import 'Component.dart';

class DragTargetComp extends StatefulWidget {
  const DragTargetComp({super.key});

  @override
  State<DragTargetComp> createState() => _DragTargetCompState();
}


class _DragTargetCompState extends State<DragTargetComp> {
  Component? comp;
  @override
  Widget build(BuildContext context) {
    if(comp==null)
    {
      return SizedBox(
        width:60,
        height:60,
        child:DragTarget(
          onAccept:(Component value){
            setState(() {
               comp=value;
            });
          },
          builder: (BuildContext context,List<dynamic>accepted,List<dynamic>rejected,)
          {
            return Container(
                            width: 60,
                            height: 60,
                            color: Colors.white,
                            child:accepted.isNotEmpty?Container(
                            width: 60,
                            height: 60,
                            color: const Color.fromRGBO(241,242,246,1),
                          ):Container(
                            width: 60,
                            height: 60,
                            color: Colors.white,
                            child:Center(child:
                            Container(
                              width:2,
                              height:2,
                              color: Colors.grey,
                            )
                            ),
                          )
                          );
          }
        ),
      );
    }else {
      return Container(
        width: 60,
        height: 60,
        color: Colors.white,
        child:(comp!.isEditing()==false)?InkWell(
          onTap:()
          {
            setState(() {
              comp!.edit(true);
            });
          },
          child: Center(child:
          Image.asset('imgs/${comp!.type}.png',
          fit: BoxFit.cover,
          width: 1000,
          )),
        ):Draggable<Component>(
                    data: comp,
                    feedback:  Container(
                    width: 60,
                    height: 60,
                    child:Center(child:
                    Image.asset('imgs/${comp!.type}.png',
                    fit: BoxFit.cover,
                    width: 1000,
                    )),
                  ),
                    childWhenDragging:Text(" ") ,
                    onDragCompleted: (){
                      setState(() {
                        comp!.edit(false);
                        comp=null;
                      });
                    },
                   onDraggableCanceled: (velocity, offset) {
                    setState(() {
                      comp!.edit(false);
                    });
                   },
                    child: Center(child:
          Image.asset('imgs/${comp!.type}.png',
          fit: BoxFit.cover,
          width: 1000,
          ))),
      );
    }
    
  }
}