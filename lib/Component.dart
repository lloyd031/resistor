class Component
{
  int angle=0;
  String type=" ";
  bool editing=false;
  String name="";
  double? resistance,voltage,current;
  Component(this.type);
  void edit(bool e)
  {
    editing=e;
  }
  void setResistance(double val)
  {
    resistance=val;
  }
  void setVoltage(double val)
  {
    voltage=val;
  }
  void setCurrent(double val)
  {
    current=val;
  }
  
}