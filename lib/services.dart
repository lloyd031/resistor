

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
}