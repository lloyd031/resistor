class Component
{
  int? index;
  int angle=0;
  String type=" ";
  bool editing=false;
  String name="";
  List<Component> connection=[];
  Component? tail,head;
  double? resistance,voltage,current;
  Component(this.type);
  
  void addConnection(Component? comp)
  {
    connection.add(comp!);
  }
  
  
}