class Component
{
  int? index;
  String type=" ";
  int angle=0;
  bool editing=false;
  String name="";
  List<Component> connection=[];
  Component? tail,head;
  double resistance=0,voltage=0,current=0;
  bool reference=false;
  Component? branch;
  int kclindex=0;
  var kcleqn;
  List<Component> eqn=[];
  Component(this.type)
  {
    if(this.type=="ground")
  {
    angle=-90;
  }
  if (type == "Resistor" ) {
      resistance=6;
    } else if (type == "Voltage") {
          voltage=12;
    } else if (type == "Current" ) {
            current=24;
            }
            
  }
  
  void addConnection(Component? comp)
  {
    connection.add(comp!);
  }
 void reset()
               {
                     branch=null;
                    if(type=="Resistor")
                          {
                            voltage=0;
                            current=0;
                          }else if(type=="wire")
                          {
                            kcleqn=List.generate(1, (index) => 0.0);
                            kclindex=0;
                            eqn.clear();
                            voltage=0;
                          }
             }
  List kcl()
  {
    for(Component i in eqn)
    {
      if(i.connection.first==this)
		  {
			 
			   if(i.current==0)			  
			   {
				   kcleqn[kclindex]+=(1/i.resistance*-1);
				   if(i.connection.last.reference==false)
				   {
					 if(i.connection.last.voltage==0)
					 {
						 kcleqn[i.connection.last.kclindex]+=1/i.resistance;
					 }else 
					 {
            kcleqn.last+=(i.connection.last.voltage/i.resistance)*-1;
						//this.setConstant(i.getConnection().getLast().getVoltage()*-1,i.getResistance());
					 }
				   }
				   if(i.voltage!=0)
					  {
						 kcleqn.last+=i.voltage/i.resistance*-1;
						 //this.setConstant(i.getVoltage()*-1,i.getResistance());
					  }
			   }else
			   {
          kcleqn.last+=i.current*-1;
				   //this.setConstant(i.getCurrent()*-1,1);
			   }

			
		  }else  
		  {	  

			  
			  if(i.current==0)
			  {
				  kcleqn[kclindex]+=(1/i.resistance*-1);
				  if(i.connection.first.voltage==0)
				  {
					  kcleqn[i.connection.first.kclindex]+=1/i.resistance;
				  }else
				  {
            kcleqn.last+=i.connection.first.voltage/i.resistance*-1;
					  //setConstant(i.getConnection().getFirst().getVoltage()*-1,i.getResistance());
					 
				  }
				  
				  if(i.voltage!=0)
				  {
          kcleqn.last+=i.voltage/i.resistance;
					//setConstant(i.getVoltage(),i.getResistance());
				  }
			  }else
			  {
           kcleqn.last+=i.current;
				  //setConstant(i.getCurrent(),1);

			  }
		 
	  }
    }
    List l=kcleqn;
    return l;
  }
  
}