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

  header_widget2 : Widget.Any_Acc :=
   Widget.Create
    (id         => "header", parent => header,
     self_flex  =>
      (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>),
     child_flex => (dir => left_right, others => <>), bgd => HAL.Bitmap.White);

  header_widget3 : Widget.Any_Acc :=
   Widget.Create
    (id         => "header", parent => header,
     self_flex  =>
      (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>),
     child_flex => (dir => left_right, others => <>), bgd => HAL.Bitmap.Red);

  middle_widget : Widget.Any_Acc :=
   Widget.Create
    (id         => "header", parent => background,
     self_flex  =>
      (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>),
     child_flex => (dir => left_right, others => <>), bgd => HAL.Bitmap.Brown);

  middle_widget2 : Widget.Any_Acc :=
   Widget.Create
    (id         => "header", parent => background,
     self_flex  =>
      (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>),
     child_flex => (dir => left_right, others => <>), bgd => HAL.Bitmap.White);

  middle_widget3 : Widget.Any_Acc :=
   Widget.Create
    (id         => "header", parent => background,
     self_flex  =>
      (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>),
     child_flex => (dir => left_right, others => <>), bgd => HAL.Bitmap.Red);

  right_widget : Widget.Any_Acc :=
   Widget.Create
    (id         => "header", parent => background2,
     self_flex  =>
      (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>),
     child_flex => (dir => left_right, others => <>), bgd => HAL.Bitmap.Brown);

  right_widget2 : Widget.Any_Acc :=
   Widget.Create
    (id         => "header", parent => background2,
     self_flex  =>
      (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>),
     child_flex => (dir => left_right, others => <>), bgd => HAL.Bitmap.White);

  right_widget3 : Widget.Any_Acc :=
   Widget.Create
    (id         => "header", parent => background2,
     self_flex  =>
      (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>),
     child_flex => (dir => left_right, others => <>), bgd => HAL.Bitmap.Red);

  header3 : Widget.Any_Acc :=
   Widget.Create
    (id         => "header", parent => header,
     self_flex  =>
      (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>),
     child_flex => (dir => left_right, others => <>), bgd => HAL.Bitmap.Brown);

  bt_example : Widget.Any_Acc :=
   Widget.Button.Create
    (id        => "BT", parent => header, text => "BT",
     self_flex =>
      (expand_w => (pixel, 50), expand_h => (pixel, 50), others => <>),
     bgd       => HAL.Bitmap.Cyan);
begin

  dui.render (STM32.Board.Display.Width, STM32.Board.Display.Height);

end Embedded_Flexbox;
