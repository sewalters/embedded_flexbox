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

procedure Test is

  header   : Widget.Any_Acc :=
   Widget.Create
    (id         => "header", parent => dui.main_widget,
     self_flex  =>
      (expand_w => (behavior => max), expand_h => (behavior => max),
       others   => <>),
     child_flex => (dir => left_right, gap_c => (pixel, 10), others => <>),
     bgd        => HAL.Bitmap.Red);
  header2  : Widget.Any_Acc :=
   Widget.Create
    (id         => "green child", parent => header,
     self_flex  =>
      (expand_w => (pixel, 50), expand_h => (pixel, 50), others => <>),
     child_flex => (dir => left_right, others => <>), bgd => HAL.Bitmap.Green);
  yeahyeah : Widget.Any_Acc :=
   Widget.Create
    (id         => "white child", parent => header,
     self_flex  =>
      (expand_w => (pixel, 50), expand_h => (pixel, 50), others => <>),
     child_flex => (dir => left_right, others => <>), bgd => HAL.Bitmap.White);
  header3  : Widget.Any_Acc :=
   Widget.Create
    (id         => "blue child", parent => header,
     self_flex  =>
      (expand_w => (pixel, 50), expand_h => (pixel, 50), align => right,
       others   => <>),
     child_flex => (dir => left_right, others => <>), bgd => HAL.Bitmap.Blue);

begin

  dui.render (STM32.Board.Display.Width, STM32.Board.Display.Height);

end Test;
