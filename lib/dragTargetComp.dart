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
  String name = "";
  String compVal = "";
  @override
  Widget build(BuildContext context) {
    void _showCompDetails() {
      String vallabel = (comp!.type == "Resistor")
          ? "Resistance"
          : (comp!.type == "Voltage")
              ? "Voltage"
              : "Current";
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              width: double.maxFinite,
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: Column(mainAxisSize: MainAxisSize.max, children: [
                Text(
                  "${comp!.type}(${comp!.name})",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  width: double.maxFinite,
                  height: 70,
                  color: const Color.fromRGBO(228, 230, 235, 1),
                  child: Center(
                    child: Transform.rotate(
                      angle: comp!.angle * 0.0174533,
                      child: SizedBox(
                        width: 60,
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
                          padding: EdgeInsets.all(8),
                          color: Colors.blueAccent,
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                comp!.name=name;
                                comp!.voltage=double.parse(compVal);
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
          });
           
            
            if (comp!.type == "Resistor" && value.resistance==null) {
            comp!.setResistance(6);
            } else if (comp!.type == "Voltage" && value.voltage==null) {
            comp!.setVoltage(12);
            } else if (comp!.type == "Current" && value.current==null) {
            comp!.setCurrent(24);
            }
            
            if(value.name=="")
            {
              String name=(value.type=="Resistor")?"R":(value.type=="Voltage")?"V":"I";
              comp!.name=name;
            }else
            {
              comp!.name=value.name;
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

      return InkWell(
        onTap: () => {
          if (comp!.editing == true)
            {
              _showCompDetails(),
            }
        },
        child: Container(
          /*decoration: (comp!.editing == false)
              ? null
              : BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(5)),*/
          width: 60,
          height: 60,
          child: (comp!.editing == false)
              ? InkWell(
                  onTap: () {
                    widget.selectComp!(comp);
                  },
                  child: Center(
                      child: Badge(
                    label: Text("${comp!.name} = $value"),
                    backgroundColor: Colors.blueAccent,
                    alignment: (comp!.angle == 90 || comp!.angle == 270)
                        ? Alignment.centerRight
                        : Alignment.topLeft,
                    child: Transform.rotate(
                      angle: comp!.angle * 0.0174533,
                      child: Image.asset(
                        'imgs/${comp!.type}.png',
                        fit: BoxFit.cover,
                        width: 1000,
                      ),
                    ),
                  )),
                )
              : Draggable<Component>(
                  data: comp,
                  feedback: Container(
                    width: 60,
                    height: 60,
                    child: Center(
                        child: Badge(
                      label: Text("${comp!.name} = $value"),
                      backgroundColor: Colors.blueAccent,
                      alignment: Alignment.topLeft,
                      child: Image.asset(
                        'imgs/${comp!.type}.png',
                        fit: BoxFit.cover,
                        width: 1000,
                      ),
                    )),
                  ),
                  childWhenDragging: Text(""),
                  onDragCompleted: () {
                    setState(() {
                      comp!.edit(false);
                      comp = null;
                    });
                  },
                  onDraggableCanceled: (velocity, offset) {
                    setState(() {
                      comp!.edit(false);
                    });
                  },
                  child: Center(
                      child: Badge(
                    label: Text("${comp!.name} = $value"),
                    backgroundColor: Colors.blueAccent,
                    alignment: Alignment.topLeft,
                    child: Image.asset(
                      'imgs/${comp!.type}.png',
                      fit: BoxFit.cover,
                      width: 1000,
                    ),
                  ))),
        ),
      );
    }
  }
}
