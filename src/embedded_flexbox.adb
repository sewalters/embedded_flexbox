with Widget;           use Widget;
with Widget.Text;      use Widget.Text;
with HAL.Bitmap;       use HAL.Bitmap;
with Ada.Finalization; use Ada.Finalization;
with STM32.Board;
with Bitmapped_Drawing;
with dui;              use dui;
procedure Embedded_Flexbox is
  header     : Widget.Any_Acc :=
   Widget.Create
    (id         => "header", parent => dui.main_widget,
     self_flex  =>
      (expand_w => (behavior => max), expand_h => (pixel, 17), others => <>),
     child_flex => (dir => left_right, others => <>), bgd => HAL.Bitmap.Red);
  header2    : Widget.Any_Acc :=
   Widget.Create
    (id         => "header", parent => dui.main_widget,
     self_flex  =>
      (expand_w => (behavior => max), expand_h => (pixel, 30), others => <>),
     child_flex => (dir => left_right, align => center, others => <>),
     bgd        => HAL.Bitmap.Green);
  header3    : Widget.Any_Acc :=
   Widget.Create
    (id         => "header", parent => dui.main_widget,
     self_flex  =>
      (expand_w => (behavior => max), expand_h => (behavior => max), others => <>),
     child_flex => (dir => left_right, others => <>), bgd => HAL.Bitmap.Blue);
  lilguytext : Widget.Any_Acc :=
   Widget.Text.Create
    (id         => "header", parent => header3,
     text       =>
      "Check out this sweet text guys! Wow!",
     self_flex  =>
      (expand_w => (behavior => max), expand_h => (pixel, 10), others => <>),
     child_flex => (dir => left_right, others => <>), foreground => Hal.Bitmap.White);
begin
  dui.render (STM32.Board.Display.Width, STM32.Board.Display.Height);
end Embedded_Flexbox;
