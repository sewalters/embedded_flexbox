with Widget;                  use Widget;
with Widget.Image;            use Widget.Image;
with Widget.Text;             use Widget.Text;
with HAL.Bitmap;              use HAL.Bitmap;
with Ada.Finalization;        use Ada.Finalization;
with STM32.Board;
with Bitmapped_Drawing;
with dui;                     use dui;
with HAL;                     use HAL;
with Bitmap_Color_Conversion; use Bitmap_Color_Conversion;
procedure Embedded_Flexbox is

  
  header : Widget.Any_Acc :=
   Widget.Create
    (id         => "header", parent => dui.main_widget,
     self_flex  =>
      (expand_w => (behavior => max), expand_h => (percent, 0.5), others => <>),
     child_flex => (dir => left_right, others => <>), bgd => HAL.Bitmap.Red);
  
    header1 : Widget.Any_Acc :=
     Widget.Image.Create
      (id         => "header", parent => header, image => "Ada",
       self_flex  =>
        (expand_w => (pixel, 150), expand_h => (behavior => max), others => <>),
       child_flex => (dir => left_right, others => <>), bgd => HAL.Bitmap.Wheat);  
    header2 : Widget.Any_Acc :=
     Widget.Image.Create
      (id         => "header", parent => header, image => "Spark",
       self_flex  =>
        (expand_w => (pixel, 150), expand_h => (behavior => max), others => <>),
       child_flex => (dir => left_right, others => <>), bgd => HAL.Bitmap.Wheat);  
    header3 : Widget.Any_Acc :=
     Widget.Image.Create
      (id         => "header", parent => header, image => "Lady_Ada",
       self_flex  =>
        (expand_w => (pixel, 150), expand_h => (behavior => max), others => <>),
       child_flex => (dir => left_right, others => <>), bgd => HAL.Bitmap.Wheat);

begin
  --  stm32.Board.Display.Hidden_Buffer(1).Set_Source(HAL.Bitmap.Red);
  --  stm32.Board.Display.Hidden_Buffer(1).Fill_Rect(Area => ( Position => (0, 0), Width => 10, Height => 10));
  --  stm32.Board.Display.Update_Layers;
  dui.render (STM32.Board.Display.Width, STM32.Board.Display.Height);

end Embedded_Flexbox;
