import 'package:flutter/material.dart';

import 'Component.dart';
import 'LineWire.dart';
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
  List<int> blocklist=[];
  Line? origin,target;
  List<Line> linelist=[];
  setStartandEnd(int i, int arm,int armIndex)
  {
    
    if(origin==null)
    {
      Line curr= Line(armIndex,null);
      origin=Line(i,null);
      origin!.setArm(curr, arm);
    }else{
      
        Line curr= Line(armIndex,null);
      target=Line(i,null);
      target!.setArm(curr,arm);
      LineWire lw=LineWire(origin, target,blocklist);
      for(Line l in lw.result())
      {

        if(inLineList(l.index!)==false)
        {
          setState(() {
          linelist.add(l);
        });
        }else{
          for(Line k in linelist)
          {
            if(k.index==l.index)
            {
              for(int q=0;q<l.arm.length; q++)
              {
                if(l.arm[q]!=null && k.arm[q]==null)
                {
                  k.setArm(l.arm[q],q);
                }
              }
            }
          }
        }
      }
      
      origin=null;
      target=null;

      }
    }
  
  void addComp(Component comp)
  {
    setState(() {
      complist.add(comp);
      blocklist.add(comp.index!);
    });
  }
 
  bool running = false;
  void run(bool val) {
    setState(() {
      running = val;
    });
  }
  Line? getLine(int index)
  {
    Line? l;
    for(Line? i in linelist)
    {
      if(i!.index==index)
      {
        l=i;
        i=linelist.last;
      }
    }
    return l;
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
 bool inLineList(int index)
 {
   bool inlinlist=false;
   for(Line i in linelist)
   {
    if(i.index==index)
    {
      inlinlist = true;
      i=linelist.last;
    }
    
   }
   
   return inlinlist;
 }

 bool inBlockList(int index)
 {
  bool inblocklist=false;
  for(int i in blocklist)
   {
    if(i==index)
    {
      inblocklist= true;
      i=blocklist.last;
    }
    
   }
   return inblocklist;
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
                        //print(complist.length);
                        
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
          const SizedBox(
                    width: double.maxFinite,
                    height: 20,
                  ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  
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
                            itemCount: 750,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return (inLineList(index)==true && inBlockList(index)==false)?LineWireModel(line: getLine(index)):DragTargetComp(
                                selectComp: selectComp, addComp:addComp,complist:complist,blocklist:blocklist, index:index, setStartandEnd: setStartandEnd,
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
