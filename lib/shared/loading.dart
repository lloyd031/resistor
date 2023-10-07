import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
            errlist.add(solveVRI);
          });
        }else
        {
          nodalAnalysis.assignVoltages();
        }
    }
    }
    r();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      color:Colors.white,
      child:  Center(
        child:(loading==false)?Column(
          children: [
             const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("OUTPUT",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 12),),
              ],
            ),
            const SizedBox(height: 6,),
            for(String i in errlist)
            ErrMessage(msg: i),

            const SizedBox(height: 50,),
          ],
        ):  Container(
          color:Colors.white,
          height: 100,
          child: const Center(
            child: Column(
              children: [
                SizedBox(height:10),
                SpinKitDoubleBounce(
                  color: const Color.fromRGBO(1,171,230,1),
                  size: 50,
                ),
                SizedBox(height:10),
                Text("Loading...", style: TextStyle(fontStyle: FontStyle.italic),),
              ],
            ),
          ),
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

