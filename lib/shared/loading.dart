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
             Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Text("OUTPUT",style: const TextStyle(fontWeight: FontWeight.bold),)),
              ],
            ),
            const SizedBox(height: 6,),
            for(String i in errlist)
            ErrMessage(msg: i)
          ],
        ):  Container(
          color:Colors.white,
          height: 100,
          child: const Center(
            child: SpinKitDoubleBounce(
              color:Color.fromRGBO(132,90,254,1),
              size: 50,
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
        child:Text("Error: $msg" , style: const TextStyle(fontSize: 14,color: Color.fromRGBO(255, 80, 164, 1)),),
      ),
    );
  }
}

