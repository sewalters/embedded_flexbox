with Ada.Text_IO; use Ada.Text_IO;
with dui;
with Hal.Bitmap; use Hal.Bitmap;
with Widget.Button;

package body Widget_Observer is
    procedure add_Widget(w: in out Widget.Any_Acc) is
    begin
        if curr_index = 100 then
            null;
        elsif event_widgets(1) = null and curr_index = 1 then
            event_widgets(1) := w;
        else
            curr_index := curr_index + 1;
            event_widgets(curr_index) := w;
        end if;
    end add_Widget;

    procedure remove_Widget(w: in out Widget.Any_Acc) is
    begin
        null;
    end remove_Widget;

    -- for button widgets
    procedure button_press_event(x_Input : Natural; y_Input : Natural) is
    begin
        for i in event_widgets'Range loop
            exit when i > curr_index;
            if event_widgets (i).Is_In_Bound (x_Input, y_Input) then
                event_widgets (i).Click;
            end if;
        end loop;
        --null;
    end button_press_event;

    -- for button widgets
    procedure button_release_event is
    begin
        for i in event_widgets'Range loop
            exit when i > curr_index;
            if event_widgets (i).Is_Clickable then
                Widget.Button.Any_Acc (event_widgets (i)).release_click;
            end if;
        end loop;
        --null;
    end button_release_event;

end Widget_Observer;