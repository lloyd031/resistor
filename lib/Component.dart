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
  
  void kcl()
  {
    for(Component i in eqn)
    {
      if(i.current==0)
      {
        kcleqn[kclindex]=(i.connection.first==this)?1/i.resistance:(1/i.resistance)*-1;
        if(i.voltage!=0)
        {
         i.kcleqn[kcleqn.length]=(i.connection.first==this)?(i.voltage)*-1:i.voltage;
        }
      }
    }
  }
  
}