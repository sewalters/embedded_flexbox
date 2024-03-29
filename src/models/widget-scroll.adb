with Ada.Text_IO; use Ada.Text_IO;
with dui;
with Hal.Bitmap; use Hal.Bitmap;
with STM32.Board;
with Widget; use Widget;

package body Widget.Scroll is
    function Create
       (id : String; parent : Widget.Any_Acc;
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
              (Ada.Finalization.Controlled with id => +id,
               min_height => min_height, min_width => min_width,
               max_height => max_height, max_width => max_width,
               self_flex => self_flex, child_flex => child_flex, bgd => bgd,
               others                              => <>);
        
        if bgd = HAL.Bitmap.White then
            Any_Acc(this).colors(idle) := bgd;
            Any_Acc(this).colors(clicking) := HAL.Bitmap.Gray;
        else
            Any_Acc(this).colors(idle) := bgd;
        end if;
        
        if parent.child_flex.dir = left_right or parent.child_flex.dir = right_left then
            Any_Acc(this).self_flex := (expand_w => (pixel, 50), expand_h => (pixel, 100), others => <>);
            Any_Acc(this).child_flex := (dir => parent.child_flex.dir,  others => <>);
        elsif parent.child_flex.dir = top_bottom or parent.child_flex.dir = bottom_top then
            Any_Acc(this).self_flex := (expand_w => (pixel, 100), expand_h => (pixel, 50), others => <>);
            Any_Acc(this).child_flex := (dir => parent.child_flex.dir,  others => <>);
        end if;
        
        Any_Acc(this).new_pw := 
            Widget.Create (id => id & ".pw", parent => parent,
            self_flex  => (expand_w => (behavior => max), expand_h => (behavior => max), others => <>),
            child_flex => (dir => parent.child_flex.dir,  others => <>), bgd => parent.bgd);
        
        dui.add_to_LOT (This, parent);
        return This;
    end Create;

    overriding 
    procedure Draw (This : in out Instance; img : in out Bitmap_Buffer'Class) is
        use STM32.Board;
    begin
        img.Set_Source (this.bgd);
        img.Fill_Rect (Area => (Position => (this.x, this.y), Width => this.w, Height => this.h));
    end Draw;

    overriding
    procedure Click (This: in out Instance) is
    begin
        if This.state = idle then
            This.state := clicking;
            This.bgd := This.colors(clicking);
        end if;
        if This.state = clicking then -- for moving the widget
            if This.child_flex.dir = left_right or This.child_flex.dir = right_left then
                null;
            elsif This.child_flex.dir = top_bottom or This.child_flex.dir = bottom_top then
                null;
            end if;
        end if;
    end Click;

    overriding
    function Is_Clickable(This: in Instance) return Boolean is
    begin
    return True;
    end Is_Clickable;

    procedure release_click(This: in out Instance) is
    begin
        if This.state = clicking then
            This.state := idle;
            This.bgd := This.colors(idle);
        end if;
    end release_click;

end Widget.Scroll;