with dui;                     use dui;

with Widget;                  use Widget;
with Widget.Text;             use Widget.Text;
with Widget.Image;            use Widget.Image;
with Widget.Button;           use Widget.Button;

with HAL;                     use HAL;
with HAL.Bitmap;              use HAL.Bitmap;

with Ada.Finalization;        use Ada.Finalization;
with Ada.Strings.Unbounded;   use Ada.Strings.Unbounded;

with Bitmap_Color_Conversion; use Bitmap_Color_Conversion;
with BMP_Fonts;               use BMP_Fonts;

with STM32.Board;             use STM32.Board;

with embedded_view;           use embedded_view;
with event_handler;

with Bitmapped_Drawing;

procedure demo_01 is

  header : Widget.Any_Acc :=
   Widget.Create
    (id         => "header", parent => dui.main_widget,
     self_flex  =>
      (expand_w => (percent, 0.33), expand_h => (behavior => max),
       others   => <>),
     child_flex =>
      (dir => bottom_top, gap_r => (pixel, 15), align => center, others => <>),
     bgd        => HAL.Bitmap.Blue);

  background : Widget.Any_Acc :=
   Widget.Create
    (id         => "header", parent => dui.main_widget,
     self_flex  =>
      (expand_w => (percent, 0.33), expand_h => (behavior => max),
       others   => <>),
     child_flex => (dir => right_left, align => bottom, others => <>),
     bgd        => HAL.Bitmap.Grey);

  background2 : Widget.Any_Acc :=
   Widget.Create
    (id         => "header", parent => dui.main_widget,
     self_flex  =>
      (expand_w => (percent, 0.33), expand_h => (behavior => max),
       others   => <>),
     child_flex =>
      (dir    => top_bottom, buoy => space_around, align => stretch,
       others => <>),
     bgd        => HAL.Bitmap.Green);

  header_widget : Widget.Any_Acc :=
   Widget.Create
    (id         => "header", parent => header,
     self_flex  =>
      (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>),
     child_flex => (dir => left_right, others => <>), bgd => HAL.Bitmap.Green);

  middle_widget : Widget.Any_Acc :=
   Widget.Create
    (id         => "header", parent => background,
     self_flex  =>
      (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>),
     child_flex => (dir => left_right, others => <>), bgd => HAL.Bitmap.Brown);

  right_widget : Widget.Any_Acc :=
   Widget.Create
    (id         => "header", parent => background2,
     self_flex  =>
      (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>),
     child_flex => (dir => left_right, others => <>), bgd => HAL.Bitmap.Brown);

begin

  dui.render (STM32.Board.Display.Width, STM32.Board.Display.Height);

end demo_01;
