with Ada.Text_IO;             use Ada.Text_IO;
with dui;
with HAL.Bitmap;              use HAL.Bitmap;
with Bitmapped_Drawing;       use Bitmapped_Drawing;
with HAL;                     use HAL;
with Bitmap_Color_Conversion; use Bitmap_Color_Conversion;
with Textures;

with Ada.Real_Time; use Ada.Real_Time;

package body Widget.Image is

    function Create
       (id : String; parent : Widget.Any_Acc; image : Texture;
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
              (Ada.Finalization.Controlled with id => +id, image => image,
               min_height => min_height, min_width => min_width,
               max_height => max_height, max_width => max_width,
               self_flex => self_flex, child_flex => child_flex, bgd => bgd,
               others                              => <>);
        dui.add_to_LOT (This, parent);
        return This;
    end Create;

    --  overriding procedure finalize (This : in out Instance) is
    --  begin
    --      null;
    --      -- if this.image /= null then
    --      --     g.free (this.image);
    --      -- end if;
    --  end;

    --  overriding procedure Event (This : in out Instance; Evt : Event_Kind) is
    --  begin
    --      null;
    --  end;

    overriding procedure Draw
       (This : in out Instance; img : in out Bitmap_Buffer'Class)
    is
        use dui;
    begin
        for I in This.image'Range loop
            for J in This.image(I)'Range loop
                declare
                    pixel_color : Bitmap_Color := 
                       Word_To_Bitmap_Color
                          (Mode => ARGB_1555,
                           Col  => UInt32 (This.image (I) (J)));
                begin
                    img.Set_Source (pixel_color);
                    img.Set_Pixel (Pt => (I, J));
                end;
            end loop;
        end loop;

    end Draw;

    --  overriding procedure Click (This : in out Instance) is
    --  begin
    --  Put_Line("I am an image widget");
    --  end;

end Widget.Image;
