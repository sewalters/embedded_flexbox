with Widget;           use Widget;
with Widget.Text;      use Widget.Text;
with Widget.Button;    use Widget.Button;
with HAL.Bitmap;       use HAL.Bitmap;
with Ada.Finalization; use Ada.Finalization;
with STM32.Board;      use STM32.Board;
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
      (expand_w => (percent, 0.5), expand_h => (behavior => max), others => <>),
     child_flex => (dir => bottom_top, gap_c => (pixel, 10), align => top,  others => <>), bgd => HAL.Bitmap.Red);
  header2    : Widget.Any_Acc :=
   Widget.Create
    (id         => "header", parent => header,
     self_flex  =>
      (expand_w => (pixel, 50), expand_h => (pixel, 50), others => <>),
     child_flex => (dir => left_right,  others => <>),
     bgd        => HAL.Bitmap.Green);
     header3    : Widget.Any_Acc :=
   Widget.Create
    (id         => "header", parent => header,
     self_flex  =>
      (expand_w => (pixel, 50), expand_h => (pixel, 50), others => <>),
     child_flex => (dir => left_right,  others => <>),
     bgd        => HAL.Bitmap.Blue);
   text_example : Widget.Any_Acc :=
      Widget.Text.Create
      (id        => "Text", parent => header, text => "Example text Example Text Example Text",
      self_flex =>
         (expand_w => (behavior => max), expand_h => (behavior => max), others => <>), overflow => wrap);
   bt_example : Widget.Any_Acc :=
      Widget.Button.Create
      (id        => "BT", parent => header, text => "Button Button Button Button Button Button ",
      self_flex =>
         (expand_w => (behavior => max), expand_h => (behavior => max), others => <>), bgd => HAL.Bitmap.Purple);
  text_example2 : Widget.Any_Acc :=
      Widget.Text.Create
      (id        => "Text", parent => header3, text => "Truncate", overflow => truncate,
      self_flex =>
         (expand_w => (behavior => max), expand_h => (behavior => max), others => <>));
begin
  --  stm32.Board.Display.Hidden_Buffer(1).Set_Source(HAL.Bitmap.Red);
  --  stm32.Board.Display.Hidden_Buffer(1).Fill_Rect(Area => ( Position => (0, 0), Width => 10, Height => 10));
  --  stm32.Board.Display.Update_Layers;
  dui.render (STM32.Board.Display.Width, STM32.Board.Display.Height);

end Embedded_Flexbox;
