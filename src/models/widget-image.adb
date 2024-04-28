with Ada.Text_IO;             use Ada.Text_IO;
with dui;
with HAL.Bitmap;              use HAL.Bitmap;
with Bitmapped_Drawing;       use Bitmapped_Drawing;
with HAL;                     use HAL;
with Bitmap_Color_Conversion; use Bitmap_Color_Conversion;
with Textures;
with Texture_Factory; 

with Ada.Real_Time; use Ada.Real_Time;

package body Widget.Image is

    function Create
       (id : String; parent : Widget.Any_Acc; image : string;
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
              (Ada.Finalization.Controlled with id => +id, image => +image,
               min_height => min_height, min_width => min_width,
               max_height => max_height, max_width => max_width,
               self_flex => self_flex, child_flex => child_flex, bgd => bgd,
               others                              => <>);
        dui.add_to_LOT (This, parent);
        return This;
    end Create;

    overriding procedure Draw
       (This : in out Instance; img : in out Bitmap_Buffer'Class)
    is
        use dui;
        image_Acc      : Texture_Access :=
           Texture_Factory.procure_texture (+This.image);
        requested_size : Float;
        start          : Natural;
        stop           : Natural;
    begin

        if This.w <= This.h then
            requested_size := Float (This.w) / 127.0; --Pull percent value to sample Image by.
        else
            requested_size := Float (This.h) / 127.0;
        end if;

        start := Natural (1.0 * requested_size);

        if start < 1 then
            start := 1;
        end if;
        
        stop := Natural (127.0 * requested_size);

        for I in start .. stop loop
            declare
                col : Texture_Column :=
                   image_Acc (Natural (Float (I) / requested_size));
            begin
                for J in start .. stop loop
                    declare
                        pixel_color : Bitmap_Color :=
                           Word_To_Bitmap_Color
                              (Mode => ARGB_1555,
                               Col  =>
                                  UInt32
                                     (col
                                         (Natural
                                             (Float (J) / requested_size))));
                    begin
                        if (This.x + I <= This.x + This.w) and
                           (This.y + J <= This.y + This.h)
                        then
                            img.Set_Source (pixel_color);
                            img.Set_Pixel (Pt => (This.x + I, This.y + J));
                        end if;
                    end;
                end loop;
            end;
        end loop;
    end Draw;

end Widget.Image;
