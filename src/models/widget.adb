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
end Widget;
