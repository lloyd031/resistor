import 'package:flutter/material.dart';

import 'Component.dart';

class DragTargetComp extends StatefulWidget {
  Function? selectComp;
  Function? addComp;
  List complist;
  List blocklist;
  int index;
  Function? setStartandEnd;
  DragTargetComp({super.key, required this.selectComp,required this.addComp, required this.complist,required this.blocklist, required this.index,required this.setStartandEnd});

  @override
  State<DragTargetComp> createState() => _DragTargetCompState();
}

class _DragTargetCompState extends State<DragTargetComp> {
  
  Component? comp;
  String name = "";
  String compVal = "";
  bool tail=false;
  bool head=false;
  @override
  Widget build(BuildContext context) {
    void _showCompDetails() {
      String vallabel = (comp!.type == "Resistor")
          ? "Resistance"
          : (comp!.type == "Voltage")
              ? "Voltage"
              : "Current";
      showModalBottomSheet(
        isScrollControlled: true,

          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(20),
              color:Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${comp!.type}(${comp!.name})",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(onPressed: (){setState(() {
                      comp=null;
                      widget.selectComp!(null);
                      Navigator.pop(context);
                    });
                    
                    }, icon: const Icon(Icons.delete, color:Colors.redAccent))
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  width: double.maxFinite,
                  height: 70,
                  color: const Color.fromRGBO(228, 230, 235, 1),
                  child: Center(
                    child: Transform.rotate(
                      angle:comp!.angle*0.0174533,
                      child: SizedBox(
                        width: 40,
                        height: 60,
                        child: Image.asset(
                          'imgs/${comp!.type}.png',
                          fit: BoxFit.cover,
                          width: 1000,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                         initialValue: comp!.name,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), hintText: "Name"),
                        onChanged: (val) {
                          name=val;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: (comp!.type=="Resistor")?"${comp!.resistance}":(comp!.type=="Voltage")?"${comp!.voltage}":"${comp!.current}",
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: vallabel,
                        ),
                        onChanged: (val) {
                          compVal=val;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                          width: double.maxFinite,
                          padding: const EdgeInsets.all(8),
                          color: Colors.blueAccent,
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  if(name!="")
                                  {
                                    comp!.name=name;
                                  }
                                  if(compVal!="")
                                  {
                                    if(comp!.type=="Resistor")
                                    {
                                      comp!.resistance=double.parse(compVal);
                                    }else if(comp!.type=="Voltage")
                                    {
                                      comp!.voltage=double.parse(compVal);
                                    }else if(comp!.type=="Current")
                                    {
                                      comp!.current=double.parse(compVal);
                                    }
                                  }
                                  widget.selectComp!(null);
                                  Navigator.pop(context);
                                });
                              },
                              child: const Text(
                                "save",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              )))
                    ],
                  ),
                )
              ]),
            );
          });
    }

    if (comp == null) {
      return SizedBox(
        width: 60,
        height: 60,
        child: DragTarget(onAccept: (Component value) {
          setState(() {
            comp = Component("${value.type}");
            comp!.resistance = value.resistance;
            comp!.voltage = value.voltage;
            comp!.current = value.current;
            comp!.angle=value.angle;
            comp!.index=widget.index;
          });
           
            
            if (comp!.type == "Resistor" && value.resistance==null) {
            comp!.resistance=6;
            } else if (comp!.type == "Voltage" && value.voltage==null) {
            comp!.voltage=12;
            } else if (comp!.type == "Current" && value.current==null) {
            comp!.current=24;
            }
            
            if(value.name=="")
            {
              String name=(value.type=="Resistor")?"R":(value.type=="Voltage")?"V":"I";
              comp!.name=name;
              widget.addComp!(comp);
            }else
            {
              comp!.name=value.name;
              widget.complist[widget.complist.indexOf(value)]=comp;
              widget.blocklist[widget.blocklist.indexOf(value.index)]=widget.index;
              
            }
        }, builder: (
          BuildContext context,
          List<dynamic> accepted,
          List<dynamic> rejected,
        ) {
          return SizedBox(
              width: 60,
              height: 60,
              child: accepted.isNotEmpty
                  ? Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color.fromRGBO(228, 230, 235, 1),
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        widget.selectComp!(null);
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        child: Center(
                            child: Container(
                          width: 2,
                          height: 2,
                          color: Colors.grey,
                        )),
                      ),
                    ));
        }),
      );
    } else {
      String value = (comp!.type == "Resistor")
          ? "${comp!.resistance}Ω"
          : (comp!.type == "Voltage")
              ? "${comp!.voltage}V"
              : "${comp!.current}A";

      return Badge(
                    label:(comp!.editing==true)? Text(""): Text("${comp!.name} = $value"),
                    backgroundColor:(comp!.editing==true)? Colors.white: Colors.blueAccent,
                    alignment: (comp!.angle == -90 || comp!.angle == -270)
                        ? Alignment.centerRight
                        : Alignment.topLeft,
                child: Transform.rotate(
                  angle:comp!.angle*0.0174533,
          child: InkWell(
            onTap: () => {
              if (comp!.editing == true)
                {
                  _showCompDetails(),
                }
            },
            child: Container(
              padding: (comp!.editing == false)
                  ? null:EdgeInsets.all(4),
              width: 60,
              height: 60,
              child: (comp!.editing == false)
                  ? InkWell(
                      onTap: () {
                        widget.selectComp!(comp);
                      },
                      child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: (){
                                 if(comp!.angle==0)
                                 {
                                  widget.setStartandEnd!(comp!.index!-1,2,comp!.index!,comp,"head");
                                 }else if(comp!.angle==-180)
                                 {
                                  widget.setStartandEnd!(comp!.index!+1,0,comp!.index!,comp,"head");
                                 }else if(comp!.angle==-270)
                                 {
                                  widget.setStartandEnd!(comp!.index!-50,3,comp!.index!,comp,"head");
                                 }
                                 else if(comp!.angle==-90)
                                 {
                                  widget.setStartandEnd!(comp!.index!+50,1,comp!.index!,comp,"head");
                                 }
                                 setState(() {
                                   head=true;
                                 });
                                },
                                child: Container(
                                  width:12,
                                  height:12,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(11),
                                    color:(head==true)?Colors.blue[200]:Colors.white,
                                    border: Border.all(color: const Color.fromRGBO(1, 48, 63, 1), width: 2.5)
                                    
                                  ),
                                  
                                ),
                              ),
                              Expanded(
                                child: Image.asset(
                                  'imgs/${comp!.type}.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  if(comp!.angle==0)
                                 {
                                  widget.setStartandEnd!(comp!.index!+1,0,comp!.index!,comp,"tail");
                                 }else if(comp!.angle==-180)
                                 {
                                  widget.setStartandEnd!(comp!.index!-1,2,comp!.index!,comp,"tail");
                                 }else if(comp!.angle==-270)
                                 {
                                  widget.setStartandEnd!(comp!.index!+50,1,comp!.index!,comp,"tail");
                                 }else if(comp!.angle==-90)
                                 {
                                  widget.setStartandEnd!(comp!.index!-50,3,comp!.index!,comp,"tail");
                                 }
                                 setState(() {
                                   tail=true;
                                 });
                                },
                                child: Container(
                                  width:12,
                                  height:12,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(11),
                                    color:(tail==true)?Colors.blue[200]:Colors.white,
                                    border: Border.all(color: const Color.fromRGBO(1, 48, 63, 1), width: 2.5)
                                    
                                  ),
                                  
                                ),
                              ),
                            ],
                          )),
                    )
                  : Draggable<Component>(
                    data: comp,
                    feedback: Container(
                      padding:const EdgeInsets.all(4),
                      width: 60,
                      height: 60,
                      child: Center(
                          child: Opacity(
                          opacity: 0.7,
                            child: Transform.rotate(
                              angle: comp!.angle*0.0174533,
                              child: Row(
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
                                    child: Image.asset(
                                      'imgs/${comp!.type}.png',
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
                              ),
                            ),
                          )),
                    ),
                    childWhenDragging: Text(""),
                    onDragCompleted: () {
                      setState(() {
                        widget.selectComp!(null);
                        comp = null;
                      });
                      
                    },
                    onDraggableCanceled: (velocity, offset) {
                      setState(() {
                        comp!.editing=false;
                      });
                    },
                    child: Center(
                        child: Opacity(
                          opacity: 0.7,
                          child: Row(
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
                                child: Image.asset(
                                  'imgs/${comp!.type}.png',
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
                          ),
                        ))),
            ),
          ),
        ),
      );
    }
  }
}
