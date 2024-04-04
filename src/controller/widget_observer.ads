with Ada.Strings.Unbounded;
with Widget; use Widget;

package Widget_Observer is
    type widget_index is range 1 .. 100;
    type widget_array is array (widget_index) of Widget.Any_Acc;
    event_widgets : widget_array;
    curr_index : widget_index := 1;

    procedure add_Widget(w: in out Widget.Any_Acc);
    procedure remove_Widget(w: in out Widget.Any_Acc);
    procedure button_press_event(x_Input : Natural; y_Input : Natural);
    procedure button_release_event;

end Widget_Observer;