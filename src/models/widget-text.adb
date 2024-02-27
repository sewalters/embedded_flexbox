with Ada.Text_IO;       use Ada.Text_IO;
with HAL.Bitmap;        use HAL.Bitmap;
with Bitmapped_Drawing; use Bitmapped_Drawing;
with dui;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

--Content needed.

--Current_Font : BMP_Fonts.BMP_Font      := BMP_Fonts.Font12x12;
--Foreground   : HAL.Bitmap.Bitmap_Color := HAL.Bitmap.White;
--Background   : HAL.Bitmap.Bitmap_Color := HAL.Bitmap.Black;
--  Bitmapped_Drawing.Draw_String
--    (Buffer     => STM32.Board.Display.Hidden_Buffer (1).all,
--     Start      => Scale ((0, 0)), Msg => "Hello, World!",
--     Font       => Current_Font, Foreground => fgd,
--     Background => bgd);

package body Widget.Text is

    function Create
       (id                    : String; parent : Widget.Any_Acc; text : String;
        font : BMP_Font     := Font12x12; self_flex : flex_t := default_flex;
        child_flex            : flex_t       := default_flex;
        min_height, min_width : Natural      := 0;
        max_height, max_width : Natural      := Natural'Last;
        fgd            : Bitmap_Color := HAL.Bitmap.White;
        bgd : Bitmap_Color := Hal.Bitmap.Black) return Widget.Any_Acc
    is
        This : Widget.Any_Acc;
    begin
        This :=
           new Instance'
              (Ada.Finalization.Controlled with id => +id, text => +text,
               self_flex             => self_flex, child_flex => child_flex,
               min_height            => min_height, min_width => min_width,
               max_height => max_height, max_width => max_width, font => font,
               fgd            => fgd, bgd => Parent.bgd,
               others                => <>);
        if Parent.bgd = HAL.Bitmap.White then
            Any_Acc(this).fgd := HAL.Bitmap.Gray;
        end if;
        dui.add_to_LOT (This, parent);
        return This;
    end Create;

    --  overriding procedure Event (This : in out Instance; Evt : Event_Kind) is
    --  begin
    --      null;
    --  end Event;

    --  overriding procedure Click (This: in out Instance) is
    --  begin
    --      null;--Put_Line("I am a Text Widget.");
    --  end;

    overriding procedure Draw
       (This : in out Instance; img : in out Bitmap_Buffer'Class)
    is
        pnt : Hal.Bitmap.Point := (this.x, this.y);
        str : String := To_String(this.text);
    begin
        Bitmapped_Drawing.Draw_String
           (Buffer => img, Start => pnt, Msg => str,
            Font       => this.font, Foreground => this.fgd,
            Background => this.bgd);
    end Draw;

end Widget.Text;
