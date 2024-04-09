with dui;              use dui;
with Widget;           use Widget;
with Widget.Text;      use Widget.Text;
with Widget.Image;     use Widget.Image;
with Widget.Button;    use Widget.Button;
with HAL;              use HAL;
with HAL.Bitmap;       use HAL.Bitmap;
with Ada.Finalization; use Ada.Finalization;
with STM32.Board;      use STM32.Board;
with embedded_view;    use embedded_view;
with event_handler;

procedure Test is

  header   : Widget.Any_Acc :=
   Widget.Create
    (id         => "header", parent => dui.main_widget,
     self_flex  =>
      (expand_w => (pixel, 200), expand_h => (pixel, 200),
       others   => <>),
     child_flex => (dir => left_right, gap_c => (pixel, 10), others => <>),
     bgd        => HAL.Bitmap.Red);

  header2 : Widget.Any_Acc :=
    Widget.Button.Create
      (id         => "header2", parent => header, 
      self_flex  =>
        (expand_w => (pixel, 40), expand_h => (pixel, 40),
          others   => <>),
      child_flex => (dir => left_right, others => <>),
      bgd        => HAL.Bitmap.Purple);
  header3  : Widget.Any_Acc :=
   Widget.Button.Create
    (id         => "blue child", parent => header,
     self_flex  =>
      (expand_w => (pixel, 60), expand_h => (pixel, 60), align => bottom,
       others   => <>),
     child_flex => (dir => left_right, others => <>), bgd => HAL.Bitmap.Blue);
  header4 : Widget.Any_Acc :=
   Widget.Create
    (id         => "white_child", parent => header,
     self_flex  =>
      (expand_w => (pixel, 50), expand_h => (pixel, 50), others => <>),
     child_flex => (dir => left_right, others => <>), bgd => HAL.Bitmap.White);

begin

  dui.render (STM32.Board.Display.Width, STM32.Board.Display.Height);

end Test;
