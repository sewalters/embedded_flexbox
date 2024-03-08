with Ada.Text_IO; use Ada.Text_IO;
with dui;
with Hal.Bitmap; use Hal.Bitmap;

package body Widget.Observer is
    function Create
       (id : String; parent : Widget.Any_Acc; temp_value : Natural := 0;
        self_flex             : flex_t  := default_flex;
        child_flex            : flex_t  := default_flex;
        min_height, min_width : Natural := 0;
        max_height, max_width : Natural := Natural'Last; bgd : Bitmap_Color)
        return Widget.Any_Acc
    is
        This : Widget.Any_Acc;
    begin
        This :=
           new Instance'
              (Ada.Finalization.Controlled with id => +id, temp_value => temp_value,
               min_height => min_height, min_width => min_width,
               max_height => max_height, max_width => max_width,
               self_flex => self_flex, child_flex => child_flex, bgd => bgd,
               others                              => <>);
        --dui.add_to_LOT (This, parent);
        return This;
    end Create;

    procedure add_Widget(w: in out Widget.Any_Acc) is
        index : Natural;
    begin
        --  for i in event_widgets'Range loop
        --      exit when event_widgets (i) = w;
        --      if event_widgets (i) = null then
        --      end if;
        --  end loop;
        null;
    end add_Widget;

    procedure remove_Widget(w: in out Widget.Any_Acc) is
    begin
        null;
    end remove_Widget;

    procedure handle_event(x_Input : Natural; y_Input : Natural) is
    begin
        for i in event_widgets'Range loop
            if event_widgets (i).Is_In_Bound (x_Input, y_Input) then
                event_widgets (i).Click;
            end if;
        end loop;
        --null;
    end handle_event;

end Widget.Observer;