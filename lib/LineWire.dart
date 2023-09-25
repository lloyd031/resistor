import 'dart:collection';

import 'package:flutter/material.dart';

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
      print("done");
      DFS(currNode);
    }

  }
  getNeighbor(Line? val)
  {
    if(val!.index!%50!=0)
    {
      validateNeighbor(val.index!-1, val);
    }

    if((val.index!+1)%50!=0)
    {
      validateNeighbor(val.index!+1, val);
    }
    if(val.index!+50<749)
    {
      validateNeighbor(val.index!+50, val);
    }

    if(val.index!-50>0)
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
          linelist.elementAt(j).setLeft(linelist.elementAt(j+1));
          linelist.elementAt(j+1).setRight(linelist.elementAt(j));
        }else if(linelist.elementAt(j).index==linelist.elementAt(j+1).index-1)
        {
          linelist.elementAt(j).setRight(linelist.elementAt(j+1));
          linelist.elementAt(j+1).setLeft(linelist.elementAt(j));
        }else if(linelist.elementAt(j).index==linelist.elementAt(j+1).index+50)
        {
          linelist.elementAt(j).setTop(linelist.elementAt(j+1));
          linelist.elementAt(j+1).setBottom(linelist.elementAt(j));
        }else if(linelist.elementAt(j).index==linelist.elementAt(j+1).index-50)
        {
          linelist.elementAt(j).setBottom(linelist.elementAt(j+1));
          linelist.elementAt(j+1).setTop(linelist.elementAt(j));
        }

        
      }
      print("done DFS");
     }
  }

  List result()
  {
    return linelist;
  }
}

class Line{
  int? index;
  Line? top, bottom, left,right;
  Line? prev;
  Line(this.index,this.prev);
  void setLeft(Line left){
    this.left=left;
  }

  void setRight(Line right){
    this.right=right;
  }
  void setTop(Line left){
    this.top=left;
  }

  void setBottom(Line right){
    this.bottom=right;
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
                      color:(widget.line!.top!=null)?Colors.blue:Colors.white,
                    ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 3,
                      color:(widget.line!.left!=null)?Colors.blue:Colors.white,
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
                      color:(widget.line!.right!=null)?Colors.blue:Colors.white,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child:Container(
                      width:3,
                      color:(widget.line!.bottom!=null)?Colors.blue:Colors.white,
                    ),
                ),
              ),
            ],
          ),
        )
    );
  }
}