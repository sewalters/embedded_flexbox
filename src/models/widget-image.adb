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

--      overriding procedure Draw(This : in out Instance; img : in out Bitmap_Buffer'Class) is
--      use dui;
--      image_Acc : Texture_Access := Texture_Factory.procure_texture(+This.image);
--      targetWidth : constant Natural := This.w;  -- Target width of the downsized image
--      targetHeight : constant Natural := This.h; -- Target height of the downsized image
--      originalWidth : constant Natural := image_Acc'Length;  -- Original width of the image
--      originalHeight : constant Natural := image_Acc'Length(1); -- Original height of the image
--      scaleX : constant Float := Float(originalWidth) / Float(targetWidth);   -- X-axis scaling factor
--      scaleY : constant Float := Float(originalHeight) / Float(targetHeight); -- Y-axis scaling factor
--      begin
--      for targetY in 1 .. targetHeight loop
--          for targetX in 1 .. targetWidth loop
--              declare
--              -- Calculate corresponding coordinates in the original image
--              originalX : constant Integer := Integer(Float(targetX - 1) * scaleX);
--              originalY : constant Integer := Integer(Float(targetY - 1) * scaleY);
            
--              -- Get the nearest pixel color from the original image
--              nearestX : constant Integer := originalX + 1;
--              nearestY : constant Integer := originalY + 1;
--              nearestColor : Bitmap_Color := Word_To_Bitmap_Color(Mode => ARGB_1555, Col => UInt32(image_Acc(nearestX)(nearestY)));
--              begin
            
--              -- Draw the nearest color at the corresponding memory address linked to the LCD screen
--              img.Set_Source(nearestColor);
--              img.Set_Pixel(Pt => (This.x + targetX, This.y + targetY));
--              end;
--          end loop;
--      end loop;
--  end Draw;


    overriding procedure Draw
       (This : in out Instance; img : in out Bitmap_Buffer'Class)
    is
        use dui;
        image_Acc : Texture_Access := Texture_Factory.procure_texture(+This.image);
    begin
        for I in image_Acc'Range loop
        declare
            col : Texture_Column := image_Acc (I);
            begin
            for J in col'Range loop
                declare
                    pixel_color : Bitmap_Color := 
                       Word_To_Bitmap_Color
                          (Mode => ARGB_1555,
                           Col  => UInt32 (col(J)));
                begin
                if(This.x + I <= This.x + This.w) and (This.y + J <= This.y + this.h) then
                    img.Set_Source (pixel_color);
                    img.Set_Pixel (Pt => (This.x + I, This.y + J));
                    end if;
                end;
            end loop;
            end;
        end loop;
    end Draw;

end Widget.Image;
