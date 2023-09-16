import 'package:flutter/material.dart';

import 'Component.dart';
import 'customwidgets.dart';
import 'dragTargetComp.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Component? selectedComp;
  List<Component> complist=[];
  
  void addComp(Component comp)
  {
    setState(() {
      complist.add(comp);
    });
  }
  void p()
  {
    for(int i=0; i<complist.length; i++)
    {
       print("${complist.elementAt(i).name} = ${complist.elementAt(i).voltage}");
    }
  }
  bool running = false;
  void run(bool val) {
    setState(() {
      running = val;
    });
  }

  void selectComp(Component? comp) {
    setState(() {
      if (selectedComp != null) {
        selectedComp!.edit(false);
      }

      selectedComp = comp;
      if (comp != null) {
        selectedComp!.edit(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(241, 242, 246, 1),
      appBar: AppBar(
        title: const Text(
          "Resistor",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(1, 48, 63, 1),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.sort),
          color: Colors.white,
        ),
        actions: (selectedComp != null)
            ? [
                IconButton(
                    onPressed: () {
                     setState(() {
                        if(selectedComp!.angle!=-270)
                        {
                          selectedComp!.angle-=90;
                        }else{
                          selectedComp!.angle=0;
                        }
                     });
                     
                    },
                    icon: const Icon(
                      Icons.rotate_left,
                      color: Colors.white,
                    )),
              ]
            : [
                IconButton(
                    onPressed: () {
                      if(running == false)
                       {
                        print(complist.length);
                        p();
                       }
                      run((running == false) ? true : false);
                       
                    },
                    icon: Icon(
                      (running == true) ? Icons.stop : Icons.play_arrow,
                      color: Colors.white,
                    )),
              ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  const SizedBox(
                    width: double.maxFinite,
                    height: 20,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    height: 900,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        width: 3000,
                        height: double.infinity,
                        color: Colors.white,
                        child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 50),
                            itemCount: 900,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return DragTargetComp(
                                selectComp: selectComp, addComp:addComp,complist:complist
                              );
                            }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: double.maxFinite,
            height: 20,
          ),
          Container(
            width: double.maxFinite,
            color: const Color.fromRGBO(1, 48, 63, 1),
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DraggableButton("Voltage"),
                DraggableButton("Current"),
                DraggableButton("Resistor"),
                DraggableButton("ground"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
