with Widget;                  use Widget;
with Widget.Text;             use Widget.Text;
with Widget.Button;           use Widget.Button;
with HAL.Bitmap;              use HAL.Bitmap;
with Ada.Finalization;        use Ada.Finalization;
with STM32.Board;             use STM32.Board;
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

  header       : Widget.Any_Acc :=
   Widget.Create
    (id         => "header", parent => dui.main_widget,
     self_flex  =>
      (expand_w => (behavior => max), expand_h => (behavior => max),
       others   => <>),
     child_flex => (dir => left_right, buoy => space_around, others => <>),
     bgd        => HAL.Bitmap.Light_Grey);
  im_example   : Widget.Any_Acc :=
   Widget.Image.Create
    (id         => "IM", parent => header, image => "Psu_Shield",
     self_flex  =>
      (expand_w => (behavior => max), expand_h => (behavior => max), others => <>),
     child_flex => (dir => left_right, others => <>), bgd => HAL.Bitmap.Green);
begin

  dui.render (STM32.Board.Display.Width, STM32.Board.Display.Height);

end Embedded_Flexbox;
