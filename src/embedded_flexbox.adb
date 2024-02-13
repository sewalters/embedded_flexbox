with Widget;           use Widget;
with Widget.Text;      use Widget.Text;
with Widget.Button;    use Widget.Button;
with HAL.Bitmap;       use HAL.Bitmap;
with Ada.Finalization; use Ada.Finalization;
with STM32.Board;      use STM32.Board;
with Bitmapped_Drawing;
with dui;              use dui;
procedure Embedded_Flexbox is
  header     : Widget.Any_Acc :=
   Widget.Create
    (id         => "header", parent => dui.main_widget,
     self_flex  =>
      (expand_w => (percent ,0.8), expand_h => (percent, 0.8), others => <>),
     child_flex => (dir => left_right, gap_c => (pixel, 10), buoy => space_nothing,  others => <>), bgd => HAL.Bitmap.Red);
  header2    : Widget.Any_Acc :=
   Widget.Create
    (id         => "header", parent => header,
     self_flex  =>
      (expand_w => (percent, 0.2), expand_h => (percent, 0.20), others => <>),
     child_flex => (dir => left_right,  others => <>),
     bgd        => HAL.Bitmap.Green);
  header3    : Widget.Any_Acc :=
   Widget.Create
    (id         => "header", parent => header,
     self_flex  =>
      (expand_w => (percent, 0.10), expand_h => (percent, 0.33), others => <>),
       child_flex => (dir => left_right, others => <>), bgd => HAL.Bitmap.Blue);
  header4    : Widget.Any_Acc :=
   Widget.Create
    (id         => "header", parent => header,
     self_flex  =>
      (expand_w => (percent, 0.2), expand_h => (pixel, 30), others => <>),
     child_flex => (dir => left_right, others => <>), bgd => HAL.Bitmap.Green);
text_example : Widget.Any_Acc :=
   Widget.Text.Create
    (id        => "Text", parent => header, text => "Example text",
     self_flex =>
      (expand_w => (behavior => max), expand_h => (behavior => max), others => <>));
bt_example : Widget.Any_Acc :=
   Widget.Button.Create
    (id        => "BT", parent => header, text => "Button",
     self_flex =>
      (expand_w => (behavior => max), expand_h => (behavior => max), others => <>), bgd => HAL.Bitmap.Cyan);
begin
  dui.render (STM32.Board.Display.Width, STM32.Board.Display.Height);
end Embedded_Flexbox;
