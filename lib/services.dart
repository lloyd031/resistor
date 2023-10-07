

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
  var matrix;
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

  
   
  Future<String> solveVRI()
  {
    String err="";
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
            i.voltage-=i.connection[j].voltage;
          }else{
            i.voltage+=i.connection[j].voltage;
          }
        }else if(i.connection[j].type=="Current")
        {
          if(i.current==0)
          {
            if(i.connection[j].head==i.connection[j-1])
          {
            i.current+=i.connection[j].current;
          }else{
            i.current-=i.connection[j].current;
          }
          }else
          {
            err="Series current source connected";
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
    return Future.delayed(Duration(microseconds: 500),()=>err);
  }
  

 void assignVoltages()
 {
  String err="";
    for(Component i in branchlist)
				{
					if(i.voltage!=0 && i.current==0 && i.resistance==0 &&  i.connection.last.reference==true)
					{
							
							i.connection.first.voltage=i.voltage;
							node.remove(i.connection.first);
						
					}
				}

    for(Component i in branchlist)
				{
					if(i.voltage!=0 && i.current==0 && i.resistance==0 &&  i.connection.last.reference==false)
					{
						if(i.connection.last.voltage!=0 && i.connection.first.voltage==0)
						{
							i.connection.first.voltage=i.voltage;
							i.connection.first.voltage+=i.connection.last.voltage;
							node.remove(i.connection.first);
						}else if(i.connection.first.voltage!=0 && i.connection.last.voltage==0)
						{
							i.connection.last.voltage=(i.voltage*-1);
							i.connection.last.voltage+= i.connection.first.voltage;
							node.remove(i.connection.last);
						}else if(i.connection.first.voltage!=0 && i.connection.last.voltage!=0)
						{
							err="Error: Voltage loop detected";
              print(err);
						}else if(i.connection.first.voltage==0 && i.connection.last.voltage==0)
						{
							err="Error: Cannot solve supernode, we'll try to fix this";
              print(err);
						}
							
					}
				}
    
    setKCLIndex();
 }

void setKCLIndex()
{
  for(int i=0; i<node.length; i++)
  {
    node[i].kclindex=i;
  }
  setMatrix();
}

void setMatrix()
{
 matrix = List<List>.generate(node.length, (i) => List<dynamic>.generate(node.length+1, (doublex) => 0.0, growable: false), growable: false);
 for(Component i in node)
 {
  i.kcleqn=List.generate(node.length+1, (double) => 0.0);
 }
for(int i=0; i<node.length;i++)
 {
  matrix[i]=node[i].kcl();
  
 }
 print("kcl output");
  print(matrix);
}


}

class MatrixAnalysis
{

}