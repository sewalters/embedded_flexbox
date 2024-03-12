with Ada.Containers.Multiway_Trees;
with Ada.Strings.Unbounded;
with STM32.Board; use STM32.Board;

--with graphic;

with widget; use widget;

package dui is

    pragma Elaborate_Body;

    package Layout_Object_Tree is new Ada.Containers.Multiway_Trees
       (Any_Acc);
    LOT         : Layout_Object_Tree.Tree;
    LOT_Root    : Layout_Object_Tree.Cursor := LOT.Root;
    main_widget : Widget.Any_Acc;
    type event_states is (idle, press);
    event_state : event_states := idle;

    --img : graphic.image_access := new graphic.image(1 .. 1920, 1 .. 1080);

    procedure add_to_LOT (Widget : Any_Acc; Parent : Any_Acc);

    type Loadable is interface;
    procedure Load (L : Loadable) is abstract;

    --  procedure draw_image(target : in out graphic.image;
    --                       img : in out graphic.image_access;
    --                       x, y  : natural;
    --                       w, h  : natural);

    --  procedure draw_rect (target : in out graphic.image;
    --                       x, y  : natural;
    --                       w, h  : natural;
    --                       c     : graphic.color);

    --  procedure draw_text (target : in out graphic.image;
    --                       text  : string;
    --                       magnification : natural;
    --                       x, y  : natural;
    --                       color : graphic.color);

    procedure render (window_width : Natural; window_height : Natural);

    --  procedure handle_click_event (x_Input, y_Input : Natural);
    --  procedure handle_release_event;

end dui;
