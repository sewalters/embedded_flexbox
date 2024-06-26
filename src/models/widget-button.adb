with Ada.Text_IO; use Ada.Text_IO;
with dui;
with Hal.Bitmap; use Hal.Bitmap;
with STM32.Board;
with Widget_Observer;

package body Widget.Button is

    function Create (id            : string;
                     parent        : Widget.Any_Acc;
                     text          : string := "";
                     overflow_text : text_overflow := truncate;
                     font : BMP_Font := Font12x12;
                     self_flex     : flex_t  := default_flex;
                     child_flex    : flex_t  := default_flex;
                     min_height, min_width : Natural := 0;
                     max_height, max_width : Natural := Natural'Last;
                     priority      : Natural := 0;
                     bgd           : Bitmap_Color) return Widget.Any_Acc is
        this : Widget.Any_Acc;
    begin
        this := new Instance' (Ada.Finalization.Controlled with
                              id            => +id,
                              self_flex     => self_flex,
                              child_flex    => child_flex,
                              min_height    => min_height, 
                              min_width     => min_width, 
                              max_height    => max_height, 
                              max_width     => max_width,
                              priority      => priority,
                              bgd           => bgd,
                              others        => <>);
        
        if bgd = HAL.Bitmap.White then
            Any_Acc(this).colors(idle) := bgd;
            Any_Acc(this).colors(clicking) := HAL.Bitmap.Gray;
        else
            Any_Acc(this).colors(idle) := bgd;
        end if;
        
        dui.add_to_LOT (This, Parent);
        Widget_Observer.add_Widget(This);
        
        if text /= "" then
        Any_Acc(this).button_text := 
            Widget.Text.Any_Acc(Widget.Text.Create
            (id        => id & ".text", parent => this, text => text, overflow => overflow_text, font => font,
            self_flex =>
                (expand_w => (behavior => max), expand_h => (behavior => max), others => <>)));
        end if;
        return This;
    end;

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
            if This.button_text /= null then
                This.button_text.bgd := This.colors(clicking);
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
            if This.button_text /= null then
                This.button_text.bgd := This.colors(idle);
            end if;
        end if;
    end release_click;

end Widget.Button;
