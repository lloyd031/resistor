import 'package:flutter/material.dart';
import 'package:resistor/shared/loading.dart';

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
  List<String> pol=["",""];
   bool loading=false;
  Component? origincomp,targetcomp;
  
  bool setStartandEnd(int i, int? arm,int armIndex,Component? comp, String headtail,Line? line)
  {
    bool success=false;
    if(origin==null)
    {
      if(comp!=null)
      {
      Line curr= Line(armIndex,null);
      setState(() {
      setState(() {
        origin=Line(i,null);
      });
      origin!.setArm(curr, arm!);
      this.pol[0]=headtail;
      origincomp=comp;
      });
      }
    }else{
      if(comp==null || origincomp!.index!=comp.index)
      {
      
      Line curr= Line(armIndex,null);
      setState(() {
        target=Line(i,null);
      });
      if(arm!=null)
      {
        target!.setArm(curr,arm);
      }
      
      if(comp==null)
      {
        success=true;
      }else
      {
        pol[1]=headtail;
        targetcomp=comp;
      }
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
      if(targetcomp!=null)
      {
        Component wire=Component("wire");
        wire.name="Wire";
        complist.add(wire);
        wire.addConnection(origincomp!);
        wire.addConnection(targetcomp!);
        origincomp!.addConnection(wire);
        targetcomp!.addConnection(wire);
        if(pol[0]=="head")
        {
          origincomp!.head=wire;
        }else{
          origincomp!.tail=wire;
        }

        if(pol[1]=="head")
        {
          targetcomp!.head=wire;
        }else{
          targetcomp!.tail=wire;
        }
        for(Line j in lw.result())
        {
          j.wire=wire;
        }
        if(targetcomp!.type=="ground" || origincomp!.type=="ground")
        {
          wire.reference=true;
        }
      }else
      {
        for(Line j in lw.result())
        {
          j.wire=line!.wire;
        }
        line!.wire!.addConnection(origincomp);
        origincomp!.addConnection(line.wire);
        if(pol[0]=="head")
        {
          origincomp!.head=line.wire;
        }else
        {
          origincomp!.tail=line.wire;
        }

        if(origincomp!.type=="ground")
        {
          line.wire!.reference=true;
        }
      }
      setState(() {
      origincomp=null;
      targetcomp=null;
      origin=null;
      target=null;
      });
     
      }
    }
    
    
      return success;
    }
  void _showRes()
  {
    showModalBottomSheet(isScrollControlled: true, context: context, builder:(context){
      return Wrap(children: [Loading(complist)]);
    });
  }
  void addComp(Component comp)
  {
    
      complist.add(comp);
      blocklist.add(comp.index!);
    
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
        selectedComp!.editing=false;
      }

      selectedComp = comp;
      if (comp != null) {
        selectedComp!.editing=true;
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
      backgroundColor: const Color.fromRGBO(30,30, 30, 1),
      appBar: AppBar(
        title: const Text(
          "Resistor",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(1,171,230,1),
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
                    onPressed: (){
                      if(running == false)
                       {
                        setState((){
                          loading=true;
                        });
                        _showRes();
                         
                       }else
                       {
                        for(Component j in complist)
                        {
                          j.reset();
                        }
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
              controller: ScrollController(
                initialScrollOffset: 200,
              ),
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  
                  SizedBox(
                    width: double.maxFinite,
                    height: 900,
                    child: SingleChildScrollView(
                      controller: ScrollController(
                        initialScrollOffset: 500,
                      ),
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        width: 3000,
                        height: double.infinity,
                        color: const Color.fromRGBO(35,35, 35, 1),
                        child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 50),
                            itemCount: 750,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return (inLineList(index)==true && inBlockList(index)==false)?LineWireModel(line: getLine(index),setStartandEnd:setStartandEnd  ):DragTargetComp(
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
            color: const Color.fromRGBO(1,171,230,1),
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
