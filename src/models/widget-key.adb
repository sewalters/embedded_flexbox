with dui; use dui;
with Widget.Text; use Widget.Text;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Widget_Observer; use Widget_Observer;

package body Widget.Key is

    function Create (id            : string;
                     parent        : Widget.Any_Acc;
                     target : Widget.Any_Acc;
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
                              target => Widget.Text.Any_Acc(target),
                              child_flex    => child_flex,
                              min_height    => min_height, 
                              min_width     => min_width, 
                              max_height    => max_height, 
                              max_width     => max_width,
                              priority      => priority,
                              bgd           => bgd,
                              others        => <>);
        
        if bgd = HAL.Bitmap.White then
            Button.Any_Acc(this).colors(idle) := bgd;
            Button.Any_Acc(this).colors(clicking) := HAL.Bitmap.Gray;
        else
            Button.Any_Acc(this).colors(idle) := bgd;
        end if;
        
        dui.add_to_LOT (This, Parent);
        Widget_Observer.add_Widget(This);
        
        if text /= "" then
        Button.Any_acc(this).button_text := 
            Widget.Text.Any_Acc(Widget.Text.Create
            (id        => id & ".text", parent => this, text => text, overflow => overflow_text, font => font,
            self_flex =>
                (expand_w => (behavior => max), expand_h => (behavior => max), others => <>)));
        end if;
        return This;
    end;


    overriding
    procedure Click (This: in out Instance) is
    begin
        if This.state = idle then
            This.state := clicking;
            This.bgd := This.colors(clicking);

            Append(This.target.text, This.button_text.text );

            if This.button_text /= null then
                This.button_text.bgd := This.colors(clicking);
            end if;
        end if;
    end Click;
end;