import 'dart:collection';

import 'package:flutter/material.dart';

import 'Component.dart';

class LineWire
{
  List<int> blocklist=[];
  Line? origin;
  Line? target;
  LineWire(this.origin,this.target,this.blocklist)
  {

    BFS(origin);
  }
  List<Line?> visited=[];
  Queue<Line?> queue=Queue<Line?>();
  BFS(Line? currNode)
  {
    visited.add(currNode);
    getNeighbor(currNode);
     if(currNode!.index==target!.index)
     {
      queue.clear();
     }
    if(queue.isNotEmpty)
    {
      BFS(queue.removeFirst());
    }else{
      for(int i=0; i<4;i++)
      {
        if(currNode.arm[i]==null && target!.arm[i]!=null)
        {
          currNode.arm[i]=target!.arm[i];
        }
      }
      DFS(currNode);
    }

  }
  getNeighbor(Line? val)
  {
    if(val!.index!%50!=0)
    {
      validateNeighbor(val.index!-1, val);
    }
    if(val.index!+50<749)
    {
      validateNeighbor(val.index!+50, val);
    }
    if((val!.index!+1)%50!=0)
    {
      validateNeighbor(val.index!+1, val);
    }
    

    if(val!.index!-50>0)
    {
      validateNeighbor(val.index!-50, val);
    }
  }

  void validateNeighbor(int i, prev)
  {
      if(!blocklist.contains(i) || (blocklist.contains(i)&&i==target!.index))
      {
      bool passed=checkVQ(i);
      if(passed==true)
      {
      Line l=Line(i, prev);
      queue.add(l);
      }
      }
  }
  bool checkVQ(int i)
  {
    bool inQueue=false;
    bool inVisited=false;
    for(int j=0;j<queue.length; j++)
    {
      if(queue.elementAt(j)!.index==i)
      {
        inQueue=true;
      }
    }

    for(int j=0;j<visited.length; j++)
    {
      if(visited.elementAt(j)!.index==i)
      {
        inVisited=true;
      }
    }
    bool passed=(inQueue==false && inVisited==false)?true:false;
    return passed;
  }
  List linelist=[];
  DFS(Line a)
  {
     linelist.add(a);
     if(a.index!=origin!.index)
     {
      DFS(a.prev!);
     }else{
      for(int j=0; j<linelist.length-1;j++)
      {
        if(linelist.elementAt(j).index==linelist.elementAt(j+1).index+1)
        {
          linelist.elementAt(j).setArm(linelist.elementAt(j+1),0);
          linelist.elementAt(j+1).setArm(linelist.elementAt(j),2);
        }else if(linelist.elementAt(j).index==linelist.elementAt(j+1).index-1)
        {
          linelist.elementAt(j).setArm(linelist.elementAt(j+1),2);
          linelist.elementAt(j+1).setArm(linelist.elementAt(j),0);
        }else if(linelist.elementAt(j).index==linelist.elementAt(j+1).index+50)
        {
          linelist.elementAt(j).setArm(linelist.elementAt(j+1),1);
          linelist.elementAt(j+1).setArm(linelist.elementAt(j),3);
        }else if(linelist.elementAt(j).index==linelist.elementAt(j+1).index-50)
        {
          linelist.elementAt(j).setArm(linelist.elementAt(j+1),3);
          linelist.elementAt(j+1).setArm(linelist.elementAt(j),1);
        }

        
      }
     }
  }

  List result()
  {
    return linelist;
  }
}

class Line{
  int? index;
  //LTRB
  List arm=[null,null,null,null];
  Line? prev;
  Component? comp;
  Line(this.index,this.prev);
  void setArm(Line arm,int i){
    this.arm[i]=arm;
  }
}
class LineWireModel extends StatefulWidget {
  Line? line;
  LineWireModel({super.key, required this.line});

  @override
  State<LineWireModel> createState() => _LineWireModelState();
}

class _LineWireModelState extends State<LineWireModel> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 60,
        height: 60,
        child:Center(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child:Container(
                      width:3,
                      color:(widget.line!.arm[1]!=null)?Colors.blue:Colors.transparent,
                    ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 3,
                      color:(widget.line!.arm[0]!=null)?Colors.blue:Colors.transparent,
                    ),
                  ),
                  Container(
                    width: 3,
                    height: 3,
                    color:Colors.blue,
                  ),
                  Expanded(
                    child: Container(
                      height: 3,
                      color:(widget.line!.arm[2]!=null)?Colors.blue:Colors.transparent,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child:Container(
                      width:3,
                      color:(widget.line!.arm[3]!=null)?Colors.blue:Colors.transparent,
                    ),
                ),
              ),
            ],
          ),
        )
    );
  }
}