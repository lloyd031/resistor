import 'package:flutter/material.dart';

import 'Component.dart';
import 'customwidgets.dart';
import 'dragTargetComp.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
   Component? selectedComp;
   void selectComp(Component comp)
   {
     setState(() {
      if(selectedComp!=null)
      {
        selectedComp!.edit(false);
      }
       selectedComp=comp;
       selectedComp!.edit(true);
     });
   }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color.fromRGBO(241,242,246,1),
      appBar: AppBar(
        title: const Text("Resistor",
        style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromRGBO(1, 48, 63, 1),
        leading: IconButton(onPressed: ()
        {

        }, icon: const Icon(Icons.sort),
        color: Colors.white,),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.play_arrow,color: Colors.white,))
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
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  
                  Container(
                    width: double.maxFinite,
                    height:900,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                          width:3000,
                          height: double.infinity,
                          color:Colors.white,
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 50), 
                            itemCount: 900,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context,index){
                              return DragTargetComp(selectComp: selectComp,);
                              
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
              width:double.maxFinite,
              color: const Color.fromRGBO(1, 48, 63, 1),
              padding: const EdgeInsets.all(8),
              child:  Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:  [
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