class Component
{
  String type=" ";
  bool editing=false;
  Component(this.type);
  void edit(bool e)
  {
    editing=e;
  }
  bool isEditing()
  {
    return editing;
  }
}