

import 'dart:collection';

class BFS{
  Line? start;
  Line? end;
  List<int> blocklist;
  BFS(this.start,this.end,this.blocklist);
  Queue<Line> queue=Queue<Line>();
  List<Line> visited=[];
  void run(Line node)
  {
    queue.remove(node);
    visited.add(node);
    getNeighbor(node.index!,node);
    if(node==end)
    { 
      queue.clear();
    }else
    {
      print("${node.index}");
    }
    if(queue.isNotEmpty)
    {
      run(queue.first);
    }else
    {
      print("dfsdfds");
    }
  }

  void getNeighbor(int i,Line prev)
  {
    if(i%50!=0)
    {
      validateNeighbor(i-1,prev);
    }
    if((i+1)%50!=0)
    {
      validateNeighbor(i+1,prev);
    }
    if(i-50>0)
    {
      validateNeighbor(i-50,prev);
    }
    if(i+50<749)
    {
      validateNeighbor(i+50,prev);
    }
    
    
  }

  void validateNeighbor(int i,Line prev)
  {
    bool inQueue=false;
    bool inVisited=false;
    if(!blocklist.contains(i))
    {
      for(int j=0; j<queue.length; j++)
      {
        if(queue.elementAt(j).index==i)
        {
          j=queue.length;
          inQueue=true;
        }
      }
      for(int j=0; j<visited.length; j++)
      {
        if(visited.elementAt(j).index==i)
        {
          j=queue.length;
          inVisited=true;
        }
      }
      if(inQueue==false && inVisited==false)
      {
      Line l=Line(i,prev);
      queue.add(l);
      }
    }
  }
}

class Line{
  Line? prev;
  int? index;
  Line(this.index, this.prev);
}