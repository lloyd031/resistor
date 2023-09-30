class Component
{
  int? index;
  String type=" ";
  int angle=0;
  bool editing=false;
  String name="";
  List<Component> connection=[];
  Component? tail,head;
  double? resistance,voltage,current;
  bool reference=false;
  Component(this.type)
  {
    if(this.type=="ground")
  {
    angle=-90;
  }
  }
  
  void addConnection(Component? comp)
  {
    connection.add(comp!);
  }
  
  
}