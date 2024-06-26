with Ada.Text_IO; use Ada.Text_IO;
with dui;
with Hal.Bitmap;  use Hal.Bitmap;
with STM32.Board;
with Widget_Observer;

package body Widget.Button.Buoy is

    function Create (id            : string;
                     parent        : Widget.Any_Acc;
                     target        : Widget.Any_Acc;
                     text          : string := "";
                     overflow_text : text_overflow := truncate;
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
                              target        => target,
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
        Button.Any_Acc(this).button_text := 
            Widget.Text.Any_Acc(Widget.Text.Create
            (id        => id & ".text", parent => this, text => text, overflow => overflow_text,
            self_flex =>
                (expand_w => (behavior => max), expand_h => (behavior => max), others => <>)));
        end if;
        return This;
    end;

    
    procedure release_click(This: in out Instance) is
    begin
        if This.state = clicking then
            This.state := idle;
            This.bgd := This.colors(idle);
            This.switch_buoy;
            if This.button_text /= null then
                This.button_text.bgd := This.colors(idle);
            end if;
        end if;
    end release_click;

    procedure switch_buoy (This : in out Instance) is
    begin

        if This.target.child_flex.buoy = space_nothing then
            This.target.child_flex.buoy := space_around;
        elsif This.target.child_flex.buoy = space_around then
            This.target.child_flex.buoy := space_evenly;
        elsif This.target.child_flex.buoy = space_evenly then
            This.target.child_flex.buoy := space_between;
        else
            This.target.child_flex.buoy := space_nothing;
        end if;

    end switch_buoy;

end Widget.Button.Buoy;
