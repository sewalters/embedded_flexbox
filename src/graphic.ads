with Hal.Bitmap; use Hal.Bitmap;
package graphic is
    green : Bitmap_Color := Hal.Bitmap.Green;
    red: Bitmap_Color := Hal.Bitmap.Red;
    blue: Bitmap_Color := Hal.Bitmap.Blue;
end graphic;

--  with Ada.Unchecked_Deallocation;

--  with System.Storage_Elements;

--  with Interfaces.Fortran;
--  use Interfaces.Fortran;

--  package graphic is

--      type color_val is delta 2.0**(-8) range 0.0 .. 1.0;
--      for color_val'size use 8;

--      type color is record
--          r, g, b, a : color_val := 0.0;
--      end record;

--      green_7 : color := (0.1,0.8,0.1,0.0);
--      green_8 : color := (0.2,0.8,0.2,0.0);
--      green_9 : color := (0.3,0.8,0.3,0.0);

--      blue_4  : color := (0.6, 0.1, 0.1, 0.0);
--      blue_5  : color := (0.6, 0.2, 0.2, 0.0);
--      blue_6  : color := (0.6, 0.3, 0.3, 0.0);

--      red_1 : color := (0.1, 0.1, 0.8, 0.0);
--      red_2 : color := (0.2, 0.2, 0.8, 0.0);
--      red_3 : color := (0.3, 0.3, 0.8, 0.0);

--      black : color := (0.0, 0.0, 0.0, 0.0);
--      white : color := (color_val'last, color_val'last, color_val'last, 0.0);

--      grey : color := (0.5, 0.5, 0.5, 0.0);
--      light_grey : color := (0.7, 0.7, 0.7, 0.0);


--      type image is array (Natural range <>, Natural range <>) of color;
--      --pragma Convention (Fortran, image);
--      type image_access is access all image;
--      --procedure Free is new Ada.Unchecked_Deallocation (image, image_access);

--      function Load_QOI (abs_filename : String) return image;
--  end graphic;
