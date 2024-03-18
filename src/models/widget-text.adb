with Bitmapped_Drawing;       use Bitmapped_Drawing;
with dui;
with Ada.Strings.Unbounded;   use Ada.Strings.Unbounded;
with Bitmap_Color_Conversion; use Bitmap_Color_Conversion;

package body Widget.Text is

    function Create
       (id                    : String; parent : Widget.Any_Acc; text : String;
        font : BMP_Font      := Font12x12; self_flex : flex_t := default_flex;
        child_flex            : flex_t        := default_flex;
        min_height, min_width : Natural       := 0;
        max_height, max_width : Natural       := Natural'Last;
        overflow              : text_overflow := default;
        text_spacing : gap_t := (pixel, 8);
        fgd                   : Bitmap_Color  := HAL.Bitmap.White;
        bgd : Bitmap_Color  := HAL.Bitmap.Black) return Widget.Any_Acc
    is
        This : Widget.Any_Acc;
    begin
        This :=
           new Instance'
              (Ada.Finalization.Controlled with id => +id, text => +text,
               self_flex => self_flex, child_flex => child_flex,
               min_height => min_height, min_width => min_width,
               max_height => max_height, max_width => max_width, font => font,
               overflow => overflow, fgd => fgd, bgd => parent.bgd,
               others                              => <>);
        if parent.bgd = HAL.Bitmap.White then
            Any_Acc (This).fgd := HAL.Bitmap.Gray;
        end if;

        This.self_flex.gap_r := text_spacing; -- Set spacing between lines.

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
        pnt          : HAL.Bitmap.Point := (This.x, This.y);
        Input_String : Unbounded_String := This.text;
        Index        : Natural          := 1;
        Word         : Unbounded_String;
        Word_Size    : Natural;
        x_font_size  : Natural;
        y_font_size  : Natural;
        line_spacing : Natural;

        function Parse_Word
           (Input_String : in Unbounded_String; Start_Index : in Natural)
            return Unbounded_String
        is
            Separator : constant Character := ' '; -- Separator character (e.g., space)
            Index     : Natural            := Start_Index; -- Initialize index
            Word      : Unbounded_String   := To_Unbounded_String (""); -- Initialize word
        begin
            -- Loop through characters until separator or end of string
            while Index <= Length (Input_String)
               and then Element (Input_String, Index) /= Separator
            loop
                -- Append character to word
                Append (Word, Element (Input_String, Index));
                Index := Index + 1;
            end loop;
            return Word;
        end Parse_Word;

    begin
        case This.self_flex.gap_r.behavior is
            when pixel =>
                line_spacing := This.self_flex.gap_r.pixel;
            when percent =>
                line_spacing := Natural(Float(This.self_flex.gap_r.percent) * Float(This.h));
            when others =>
                line_spacing := 8; --8 pixels will be default spacing unless provided otherwise.
        end case;

        case This.font is
            when Font8x8 =>
                x_font_size := 8;
                y_font_size := 8;
            when Font12x12 =>
                x_font_size := 12;
                y_font_size := 12;
            when Font16x24 =>
                x_font_size := 16;
                y_font_size := 24;
        end case;

        case This.overflow is
            when default =>
                -- STANDARD BEHAVIOR
                Bitmapped_Drawing.Draw_String
                   (Buffer => img, Start => pnt, Msg => To_String (This.text),
                    Font       => This.font, Foreground => This.fgd,
                    Background => This.bgd);

            when truncate =>
                -- TRUNCATION BEHAVIOR
                for index in 1 .. Length (This.text) loop
                    declare
                        ch : Character := Element (This.text, index);
                    begin
                        if ((pnt.X + x_font_size) <= (This.x + This.w)) then--check if not OOB
                            if (ch /= ' ') then --check if not whitespace
                                Bitmapped_Drawing.Draw_Char
                                   (Buffer => img, Start => pnt, Char => ch,
                                    Font       => This.font,
                                    Foreground => Bitmap_Color_To_Word(ARGB_1555, This.fgd),
                                    Background => Bitmap_Color_To_Word(ARGB_1555, This.bgd));--draw char
                            end if;
                        end if;
                        pnt.X := pnt.X + x_font_size;
                    end;
                end loop;

            when wrap =>
                -- WRAP-TEXT BEHAVIOR
                while Index <= Length (Input_String) loop
                    -- Parse the word starting at the current index
                    Word := Parse_Word (Input_String, Index);

                    -- Get Size of Word
                    Word_Size := Length (Word) * x_font_size;

                    if Word_Size > (This.x + This.w) then
                        declare
                            c : Character;
                            div : Character := '-';
                        begin
                          for J in 1 .. Length(Word) loop
                            c := Element(Word, J);

                            if (pnt.x + x_font_size) <= (This.x + This.w - x_font_size) then
                                Bitmapped_Drawing.Draw_Char
                                  (Buffer => img,
                                   Start => pnt,
                                   Char => c,
                                   Font => This.font,
                                   Foreground => Bitmap_Color_To_Word(ARGB_1555, This.fgd),
                                   Background => Bitmap_Color_To_Word(ARGB_1555, This.bgd));
                                
                                pnt.x := pnt.x + x_font_size;

                            else
                              Bitmapped_Drawing.Draw_Char
                                  (Buffer => img,
                                   Start => pnt,
                                   Char => div,
                                   Font => This.font,
                                   Foreground => Bitmap_Color_To_Word(ARGB_1555, This.fgd),
                                   Background => Bitmap_Color_To_Word(ARGB_1555, This.bgd));

                              pnt.x := This.x;
                              pnt.y := pnt.y + y_font_size + line_spacing;

                              Bitmapped_Drawing.Draw_Char
                                  (Buffer => img,
                                   Start => pnt,
                                   Char => c,
                                   Font => This.font,
                                   Foreground => Bitmap_Color_To_Word(ARGB_1555, This.fgd),
                                   Background => Bitmap_Color_To_Word(ARGB_1555, This.bgd));
                                
                                pnt.x := pnt.x + x_font_size;
                              
                            end if;

                          end loop;
                        end;

                    elsif (pnt.X + Word_Size) <= (This.x + This.w) then
                        -- Print the word
                        Bitmapped_Drawing.Draw_String
                           (Buffer     => img, Start => pnt,
                            Msg        => To_String (Word), Font => This.font,
                            Foreground => This.fgd, Background => This.bgd);

                        --Shift offset Point.
                        pnt.X := pnt.X + (Length (Word) * x_font_size) + x_font_size;

                    else
                        if (pnt.Y + y_font_size + line_spacing) <= (This.y + This.h) then
                            pnt.X := This.x;
                            pnt.Y := pnt.Y + y_font_size + line_spacing;
                            -- Print the word
                            Bitmapped_Drawing.Draw_String
                               (Buffer     => img, Start => pnt,
                                Msg => To_String (Word), Font => This.font,
                                Foreground => This.fgd,
                                Background => This.bgd);

                            --Shift offset Point.
                            pnt.X := pnt.X + (Length (Word) * x_font_size) + x_font_size;
                        else
                            Index := Length (Input_String) + 1; --set Index to terminal value to end print.
                        end if;
                    end if;

                    -- Move the index to the next word
                    Index := Index + Length (Word) + 1; -- Add 1 for the space separator
                end loop;
        end case;
    end Draw;

end Widget.Text;