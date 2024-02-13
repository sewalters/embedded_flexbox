with Ada.Text_IO; use Ada.Text_IO;
with dui;
with Hal.Bitmap; use Hal.Bitmap;
with STM32.Board;
with Widget.Text; use Widget.Text;

package body Widget.Button is

    function Create (id            : string;
                     parent        : Widget.Any_Acc;
                     text          : string := "";
                     self_flex     : flex_t  := default_flex;
                     child_flex    : flex_t  := default_flex;
                     min_height, min_width : Natural := 0;
                     max_height, max_width : Natural := Natural'Last;
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
                              bgd           => bgd,
                              others        => <>);
        --Any_Acc(this).colors(idle) := bgd;
        dui.add_to_LOT (This, Parent);
--          if text /= "" then
--          Any_Acc(this).button_text := Widget.Text.Create (id         => id & ".text",
--                                                  parent     => this,
--                                                  text       => text,
--                                                  self_flex  => (expand_w => (behavior => max),
--                                                                 expand_h => (behavior => max),
--                                                                 others   => <>),
--                                                  child_flex => (dir    => left_right,
--                                                                 others => <>),
--                                                  min_height => min_height, 
--                                                  min_width => min_width, 
--                                                  max_height => max_height, 
--                                                  max_width => max_width,
--                                                  bgd        => bgd);--this variable affects the color of the button
--          end if;
        return This;
    end;

--      overriding
--      procedure Event (This : in out Instance; Evt : Event_Kind) is
--      begin
--          Put_Line("==================== --> Button Clicked!! <-- ======================");
--      end Event;

    overriding 
    procedure Click (This: in out Instance) is
    begin
        if This.state = idle then
        This.state := clicking;
        This.bgd := This.colors(clicking);
        --This.button_text.bgd := This.bgd;
        --Put_Line("I am a button widget.");
        else
        This.state := idle;
        This.bgd := This.colors(idle);
        --This.button_text.bgd := This.bgd;
        end if;
    end;

--     overriding
--     function Is_Clickable(This: in Instance) return Boolean is
--     begin
--     return True;
--     end Is_Clickable;

--     procedure release_click(This: in out Instance) is
--     begin
--          if This.state = clicking then
--              This.state := idle;
--              This.bgd := This.colors(idle);
--              --This.button_text.bgd := This.colors(idle);
--          end if;
--     end release_click;
    
    overriding 
    procedure Draw (This : in out Instance; img : in out Bitmap_Buffer'Class) is
        use STM32.Board;
    begin
        img.Set_Source (this.bgd);
        img.Fill_Rect (Area => (Position => (this.x, this.y), Width => this.w, Height => this.h));
    end Draw;

end Widget.Button;
