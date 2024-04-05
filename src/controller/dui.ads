with Ada.Containers.Multiway_Trees;
with Ada.Strings.Unbounded;
with STM32.Board; use STM32.Board;

with Widget; use Widget;

package dui is

    pragma Elaborate_Body;

    package Layout_Object_Tree is new Ada.Containers.Multiway_Trees (Any_Acc);
    LOT         : Layout_Object_Tree.Tree;
    LOT_Root    : Layout_Object_Tree.Cursor := LOT.Root;
    main_widget : Widget.Any_Acc;
    type event_states is (idle, press, drag, resize);
    event_state      : event_states := idle;
    update_render    : Boolean      := False;
    start_dist       : Float;
    start_w, start_h : Natural;
    start_drag_x , start_drag_y : Natural;
    event_target : Widget.Any_Acc; -- When event is Drag, or Resize set target widget to this access pointer.
    drag_target_1, drag_target_2 : Widget.Any_Acc;

    procedure add_to_LOT (Widget : Any_Acc; Parent : Any_Acc);
    type Loadable is interface;
    procedure Load (L : Loadable) is abstract;

    procedure render (window_width : Natural; window_height : Natural);

end dui;
