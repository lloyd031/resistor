import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Component.dart';
import '../services.dart';

class Loading extends StatefulWidget {
  List? complist;
  Loading(this.complist);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  bool loading=true;
  List errlist=[];
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    CheckErr ce=CheckErr(widget.complist);
    void r()async
    {
      dynamic res=await ce.getErr();
      if(res.isNotEmpty)
    {
      setState(() {
        loading=false;
        errlist=res;
      });
    }else
    {
       NodalAnalysis nodalAnalysis=NodalAnalysis(widget.complist);
       nodalAnalysis.definNodes();
       nodalAnalysis.defineBranches();
       dynamic solveVRI=await nodalAnalysis.solveVRI();
        if(solveVRI!="")
        {
          setState(() {
            loading=false;

          });
        }else
        {
          String av=await nodalAnalysis.assignVoltages();
          if(av=="")
          {
            List mat=nodalAnalysis.setKCLIndex();
            MatrixAnalysis ma= MatrixAnalysis(mat);
            List analysis=await ma.startAnalysis();
             
            bool res = await nodalAnalysis.assignVontalagestoNodes(analysis);
            if(res==true)
            {
              setState(() {
              loading=false;
          });
            }
          }else
          {
            if(av=="0 nodes")
            {
              dynamic svi=await nodalAnalysis.solveI();
              if(svi==true)
              {
                setState(() {
                loading=false;
              });
              }
            }else
            {
            setState(() {
            loading=false;
            errlist.add(av);
          });
            }
            
          }
        }
    }
    }
    r();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color:Colors.white,
      child:  Center(
        child:Column(
          children: [
            (loading==false)?Column(
          children: [
             const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("OUTPUT",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 12),),
              ],
            ),
            const SizedBox(height: 6,),
            Column(
              children: (errlist.isEmpty)?[
                for(Component i in widget.complist!)
                   (i.type!="Resistor")?const SizedBox():ErrMessage(msg: "${i.name} (${i.resistance}) ${i.current}"),
              ]:[
              for(String i in errlist)
              ErrMessage(msg: i),
              ],
            ),
            
          ],
        ):  Container(
            color:Colors.white,
            height: 100,
            child: const Center(
         child: Column(
           children: [
             Column(
               children: [
                 SizedBox(height:10),
                 SpinKitDoubleBounce(
                   color:  Color.fromRGBO(1,171,230,1),
                   size: 50,
                 ),
                 SizedBox(height:10),
                 Text("Loading...", style: TextStyle(fontStyle: FontStyle.italic),),
                 SizedBox(height: 10,),
                 
               ],
             ),
             
           ],
         ),
            ),
          ),
          SizedBox(height: 50,),
          ],
          
        ),
      ),
    );
  }
}
class ErrMessage extends StatelessWidget {
  String msg;
   ErrMessage({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(6),
        color:Colors.red[50],
        child:Text("Error: $msg" , style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14,color: Color.fromRGBO(255, 80, 164, 1)),),
      ),
    );
  }
}

