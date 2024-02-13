with Widget;                  use Widget;
with Widget.Image;            use Widget.Image;
with Widget.Text;             use Widget.Text;
with HAL.Bitmap;              use HAL.Bitmap;
with Ada.Finalization;        use Ada.Finalization;
with STM32.Board;
with Bitmapped_Drawing;
with Textures;                use Textures;
with Textures.Ada;
with Textures.Lady_Ada;
with dui;                     use dui;
with HAL;                     use HAL;
with Bitmap_Color_Conversion; use Bitmap_Color_Conversion;
procedure Embedded_Flexbox is

  img : Texture := Textures.Ada.Bmp;
  header : Widget.Any_Acc :=
   Widget.Image.Create
    (id         => "header", parent => dui.main_widget, image => img,
     self_flex  =>
      (expand_w => (percent, 0.5), expand_h => (percent, 0.5), others => <>),
     child_flex => (dir => left_right, others => <>), bgd => HAL.Bitmap.Red);

begin
  --  stm32.Board.Display.Hidden_Buffer(1).Set_Source(HAL.Bitmap.Red);
  --  stm32.Board.Display.Hidden_Buffer(1).Fill_Rect(Area => ( Position => (0, 0), Width => 10, Height => 10));
  --  stm32.Board.Display.Update_Layers;
  dui.render (STM32.Board.Display.Width, STM32.Board.Display.Height);

    --STM32.Board.Display.Initialize;
    --STM32.Board.Display.Initialize_Layer (1, HAL.Bitmap.ARGB_1555);

  --    for N in 1 .. 600 loop
  --    for I in img'Range loop
  --      for J in img(i)'Range loop
  --          declare
  --          pixel_color : Bitmap_Color := Word_To_Bitmap_Color(Mode => ARGB_1555, Col => UInt32(img(i)(j)));
  --          begin
  --            Stm32.Board.Display.Hidden_Buffer(1).Set_Source(pixel_color);
  --            stm32.Board.Display.Hidden_Buffer(1).Set_Pixel(Pt => (i, j));
  --          end;
  --      end loop;
  --    end loop;
  --    stm32.Board.Display.Update_Layers;
  --  end loop;

end Embedded_Flexbox;
