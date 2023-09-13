import 'package:flutter/material.dart';

import 'Component.dart';

class DragTargetComp extends StatefulWidget {
   Function? selectComp;
   DragTargetComp({super.key, required this.selectComp});

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
               comp=Component("${value.type}");
               comp!.resistance=value.resistance;
               comp!.voltage=value.voltage;
               comp!.current=value.current;
            });
            if(comp!.type=="Resistor")
            {
              comp!.setResistance(6);
            }else if(comp!.type=="Voltage")
            {
              comp!.setVoltage(12);
            }else if(comp!.type=="Current")
            {
              comp!.setCurrent(24);
            }
          },
          builder: (BuildContext context,List<dynamic>accepted,List<dynamic>rejected,)
          {
            return SizedBox(
                            width: 60,
                            height: 60,
                            child:accepted.isNotEmpty?Container(
                            width: 60,
                            height: 60,
                            decoration:BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color.fromRGBO(228,230, 235, 1),
                            ),
                          ):Container(
                            width: 60,
                            height: 60,
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
      String value=(comp!.type=="Resistor")?"${comp!.resistance}Ω":(comp!.type=="Voltage")?"${comp!.voltage}V":"${comp!.current}A";
      
      return Badge(
        label: Text(value),
        backgroundColor:  Colors.blueAccent,
        alignment: Alignment.topLeft,
        child: Container(
          decoration:(comp!.isEditing()==false)?null: BoxDecoration(
         border: Border.all(color: Colors.blueAccent),
         borderRadius: BorderRadius.circular(5)
        ),
          width: 60,
          height: 60,
          child:(comp!.isEditing()==false)?InkWell(
            onTap:()
            {
              widget.selectComp!(comp);
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
                      childWhenDragging:Text("") ,
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
        ),
      );
    }
    
  }
}