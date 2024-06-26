with dui;
with Ada.Text_IO;
with STM32.Board;
package body Widget is

    function Create
       (id                    : String; parent : Widget.Any_Acc;
        self_flex             : flex_t  := default_flex;
        child_flex            : flex_t  := default_flex;
        priority              : Natural := 0;
        min_height, min_width : Natural := 0;
        max_height, max_width : Natural := Natural'Last; bgd : Bitmap_Color)
        return Widget.Any_Acc
    is
        This : Widget.Any_Acc;
    begin
        This :=
           new Instance'
              (Ada.Finalization.Controlled with id => +id,
               self_flex => self_flex, child_flex => child_flex,
               priority => priority,
               min_height => min_height, min_width => min_width,
               max_height => max_height, max_width => max_width, bgd => bgd,
               others                              => <>);
        dui.add_to_LOT (This, parent);
        return This;
    end Create;

    function Is_In_Bound (This : in out Instance; x_Input : Natural; y_Input : Natural) return Boolean is
        returnval : Boolean;
    begin
        returnval := ((This.x <= x_Input) and ((This.x + This.w) >= x_Input)) and ((This.y <= y_Input) and ((This.y + This.h) >= y_Input));
        return returnval;
    end;

    procedure Set_Width (This : in out Instance; calculated_width : Natural) is
    begin
        if calculated_width < This.min_width then
            This.w :=
               This
                  .min_width; --If the given width is less than our minimum width, set Widget to min_width.
        elsif calculated_width > This.max_width then
            This.w :=
               This
                  .max_width; --If the given width is greater than the maximum width, set Widget to max_width.
        else
            This.w :=
               calculated_width; --Else, we are in range of width and can set to given width.
        end if;
    end Set_Width;

    procedure Set_Height (This : in out Instance; calculated_height : Natural)
    is
    begin
        if calculated_height < This.min_height then
            This.h :=
               This
                  .min_height; --If the given height is less than the min_height, set widget to min_height.
        elsif calculated_height > This.max_height then
            This.h :=
               This
                  .max_height; --If the given height is greater than the max_height, set widget to max_height.
        else
            This.h :=
               calculated_height; --Else, we are in range for our widgets height, and can set the height to be the given height.
        end if;
    end Set_Height;

    procedure Draw (This : in out Instance; img : in out Bitmap_Buffer'Class) is
        use STM32.Board;
    begin
        img.Set_Source (this.bgd);
        img.Fill_Rect (Area => (Position => (this.x, this.y), Width => this.w, Height => this.h));
    end Draw;

    procedure Click (This : in out Instance) is
    begin
        null;
    end Click;

    function Is_Clickable(This: in Instance) return Boolean is
    begin
    return False;
    end Is_Clickable;
   function Set_Event_Override_Width(This: in out Instance; Parent: Widget.Any_Acc; new_width : Natural) return Natural is
   begin
        if new_width > Parent.w then
            This.self_flex.expand_w := (pixel, Parent.w);
            This.w := Parent.w;
        elsif new_width < 1 then
            This.self_flex.expand_w := (pixel, 1);
            This.w := 1;
        else
            This.self_flex.expand_w := (pixel, new_width);
            This.w := new_width;
        end if;
        return This.self_flex.expand_w.pixel;
   end Set_Event_Override_Width;
   function Set_Event_Override_Height(This: in out Instance;Parent: Widget.Any_Acc; new_height : Natural) return Natural is
    begin
        if new_height > Parent.h then
            This.self_flex.expand_h := (pixel, Parent.h);
            This.h := Parent.h;
        elsif new_height < 1 then
            This.self_flex.expand_h := (pixel, 1);
            This.h := 1;
        else
            This.self_flex.expand_h := (pixel, new_height);
            This.h := new_height;
        end if;
        return This.self_flex.expand_h.pixel;
    end Set_Event_Override_Height;

   function On_Boundary(This: in out Instance; x: Natural; y : Natural) return Boolean is
        forgiveness : Integer := 5; -- 5 px forgiveness for boundary.
        int_x, int_y, int_wx, int_yh, int_xc, int_yc : Integer;
   begin
        int_x := Integer(This.x);
        int_y := Integer(This.y);
        int_wx := Integer(This.x + This.w);
        int_yh := Integer(This.y + This.h);
        int_xc := Integer(x);
        int_yc := Integer(y);
        return ((( (int_xc < int_x + forgiveness) and ( int_xc > int_x - forgiveness)) or
        ( (int_xc < int_wx + forgiveness) and ( int_xc > int_wx - forgiveness)))  and ((int_yc >= int_y) and (int_yc <= int_yh))) or
        ((( (int_yc < int_y + forgiveness) and ( int_yc > int_y - forgiveness)) or
        ( (int_yc < int_yh + forgiveness) and ( int_yc > int_yh - forgiveness))) and ((int_xc >= int_x) and (int_xc <= int_wx)));


   end On_Boundary;
end Widget;
