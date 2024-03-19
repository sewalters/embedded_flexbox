with Ada.Containers.Multiway_Trees;
with Ada.Strings.Unbounded;
with STM32.Board; use STM32.Board;

with widget; use widget;

package dui is

    pragma Elaborate_Body;

    package Layout_Object_Tree is new Ada.Containers.Multiway_Trees
       (Any_Acc);
    LOT         : Layout_Object_Tree.Tree;
    LOT_Root    : Layout_Object_Tree.Cursor := LOT.Root;
    main_widget : Widget.Any_Acc;
    type event_states is (idle, press, resize);
    event_state : event_states := idle;
    update_render : Boolean := false;
    start_dist : Float;
    start_w, start_h : Natural;

    procedure add_to_LOT (Widget : Any_Acc; Parent : Any_Acc);

    type Loadable is interface;
    procedure Load (L : Loadable) is abstract;

    procedure render (window_width : Natural; window_height : Natural);

end dui;
