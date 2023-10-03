

import 'Component.dart';

class CheckErr
{
  List? complist;
  CheckErr(this.complist);
  Future<List<String>> getErr()
{
  List<String> err=[];
  bool hasGround=false;
  if(complist!.isNotEmpty)
  {
    for(int i=0; i<complist!.length; i++)
   {
      if(complist![i].connection.length<2 && complist![i].type!="ground")
       {
         err.add("incomplete connection at ${complist![i].type} (${complist![i].name})");
       }
       if(complist![i].type=="wire" && complist![i].reference==true)
       {
        hasGround=true;
       }
   }
  if(hasGround==false)
  {
    err.add("Missing reference node");
  }
  }else{
    err.add("No circuit connection found");
  }
 return Future.delayed(Duration(seconds: 5),()=> err);
}
}
class NodalAnalysis
{
  List? complist;
  NodalAnalysis(this.complist);
  List node=[];
  List branchlist=[];
  Component? currNode;
  void definNodes()
  {
    for(Component i in complist!)
    {
      if(i.type=="wire" && i.connection.length>2 && i.reference==false)
      {
        node.add(i);
      }
    }
    print("you got ${node.length} nodes");
  }

  void defineBranches()
  {
    for(Component i in node)
    {
      currNode=i;
       for(Component j in i.connection)
       {
          Component branch = Component("Branch");
          branch.addConnection(i);
          createBranch(j,i,branch);
       }
    }
  }

  void createBranch(Component comp,Component prev,Component branch)
  {
    if(comp.branch==null)
    {
      if(comp.connection.length<3)
      {
        branch.addConnection(comp);
        comp.branch=branch;
        for(Component j in comp.connection)
        {
          if(j!=prev)
          {
            createBranch(j, comp, branch);
          }
        }
      }else{
        branch.addConnection(comp);
        comp.eqn.add(branch);
        currNode!.eqn.add(branch);
        branchlist.add(branch);
      }
    }
  }

  
   
  void solveVR()
  {
    String connection="";
    print("you got ${branchlist.length}");
    for(Component i in branchlist)
    {
      for(int j=0; j<i.connection.length; j++)
      {
        //connection+=" ${i.connection[j].type}";
        if(i.connection[j].type=="Resistor")
        {
          i.resistance+=i.connection[j].resistance;
        }else if(i.connection[j].type=="Voltage")
        {
          if(i.connection[j].head==i.connection[j-1])
          {
            i.voltage+=i.connection[j].voltage;
          }else{
            i.voltage-=i.connection[j].voltage;
          }
        }
      }
      
      
    }
    for(Component i in branchlist)
    {
      connection+=" ${i.voltage} , ${i.resistance}";
      print(connection);
      connection="";
    }
  }
  
  
double add(double a, double b)
{
  double sum = a+b;
  return sum;
}

}