with dui;              use dui;
with Widget;           use Widget;
with Widget.Text;      use Widget.Text;
with Widget.Image;     use Widget.Image;
with Widget.Button;    use Widget.Button;
with Widget.Button.Switch; use Widget.Button.Switch;
with Widget.Button.Buoy; use Widget.Button.Buoy;
with HAL;              use HAL;
with HAL.Bitmap;       use HAL.Bitmap;
with Ada.Finalization; use Ada.Finalization;
with STM32.Board;      use STM32.Board;
with embedded_view;    use embedded_view;
with event_handler;

procedure kd_static is

bg1 : Widget.Any_Acc :=
   Widget.Create
    (id         => "bg1", parent => dui.main_widget,
     self_flex  =>
      (expand_w => (behavior => max), expand_h => (behavior => max),
       others   => <>),
     child_flex =>
      (dir => left_right, others => <>),
     bgd        => HAL.Bitmap.Blue);
     

     ch1_bg1 : Widget.Any_Acc :=
   Widget.Create
    (id         => "ch1_bg1", parent => bg1,
     self_flex  =>
      (expand_w => (behavior => max), expand_h => (behavior => max),
       others   => <>),
     child_flex =>
      (dir => bottom_top, others => <>),
     bgd        => HAL.Bitmap.Red);

     child : Widget.Any_Acc :=
   Widget.Create
    (id         => "child", parent => ch1_bg1,
     self_flex  =>
      (expand_w => (behavior => max), expand_h => (pixel, 50),
       others   => <>),
     child_flex =>
      (dir => left_right, gap_c => (pixel, 15), align => bottom, others => <>),
     bgd        => HAL.Bitmap.Red);

     child2 : Widget.Any_Acc :=
   Widget.Create
    (id         => "child", parent => ch1_bg1,
     self_flex  =>
      (expand_w => (behavior => max), expand_h => (pixel, 50),
       others   => <>),
     child_flex =>
      (dir => left_right, gap_c => (pixel, 15), align => center, others => <>),
     bgd        => HAL.Bitmap.Red);

     child_of_red1 : Widget.Any_Acc :=
   Widget.Create
    (id         => "child_of_red1", parent => child,
     self_flex  =>
      (expand_w => (pixel, 30), expand_h => (pixel, 30),
       others   => <>),
     child_flex =>
      (dir => left_right, others => <>),
     bgd        => HAL.Bitmap.Brown);

     child_of_red2 : Widget.Any_Acc :=
   Widget.Create
    (id         => "child_of_red2", parent => child,
     self_flex  =>
      (expand_w => (pixel, 30), expand_h => (pixel, 30),
       others   => <>),
     child_flex =>
      (dir => left_right, others => <>),
     bgd        => HAL.Bitmap.White);

     child_of_red3 : Widget.Any_Acc :=
   Widget.Create
    (id         => "child_of_red3", parent => child,
     self_flex  =>
      (expand_w => (pixel, 30), expand_h => (pixel, 30),
       others   => <>),
     child_flex =>
      (dir => left_right, others => <>),
     bgd        => HAL.Bitmap.Blue);

     child_of_red4 : Widget.Any_Acc :=
   Widget.Create
    (id         => "child_of_red4", parent => child,
     self_flex  =>
      (expand_w => (pixel, 30), expand_h => (pixel, 30),
       others   => <>),
     child_flex =>
      (dir => left_right, others => <>),
     bgd        => HAL.Bitmap.Purple);

     ch2_bg1 : Widget.Any_Acc :=
   Widget.Create
    (id         => "ch2_bg1", parent => bg1,
     self_flex  =>
      (expand_w => (behavior => max), expand_h => (behavior => max),
       others   => <>),
     child_flex =>
      (dir => left_right, align => center, buoy => space_around, others => <>),
     bgd        => HAL.Bitmap.Cyan);

     child_of_cyan1 : Widget.Any_Acc :=
   Widget.Create
    (id         => "child_of_cyan1", parent => ch2_bg1,
     self_flex  =>
      (expand_w => (pixel, 30), expand_h => (pixel, 30),
       others   => <>),
     child_flex =>
      (dir => left_right, others => <>),
     bgd        => HAL.Bitmap.Brown);

     child_of_cyan2 : Widget.Any_Acc :=
   Widget.Create
    (id         => "child_of_cyan2", parent => ch2_bg1,
     self_flex  =>
      (expand_w => (pixel, 30), expand_h => (pixel, 30), align => bottom,
       others   => <>),
     child_flex =>
      (dir => left_right, others => <>),
     bgd        => HAL.Bitmap.White);

     child_of_cyan3 : Widget.Any_Acc :=
   Widget.Create
    (id         => "child_of_cyan3", parent => ch2_bg1,
     self_flex  =>
      (expand_w => (pixel, 30), expand_h => (pixel, 30),
       others   => <>),
     child_flex =>
      (dir => left_right, others => <>),
     bgd        => HAL.Bitmap.Blue);

     child_of_cyan4 : Widget.Any_Acc :=
   Widget.Create
    (id         => "child_of_cyan4", parent => ch2_bg1,
     self_flex  =>
      (expand_w => (pixel, 30), expand_h => (pixel, 30),
       others   => <>),
     child_flex =>
      (dir => left_right, others => <>),
     bgd        => HAL.Bitmap.Purple);

     bg2 : Widget.Any_Acc :=
   Widget.Create
    (id         => "bg2", parent => dui.main_widget,
     self_flex  =>
      (expand_w => (behavior => max), expand_h => (behavior => max),
       others   => <>),
     child_flex =>
      (dir => left_right, others => <>),
     bgd        => HAL.Bitmap.Blue);

     ch1_bg2 : Widget.Any_Acc :=
   Widget.Create
    (id         => "ch1_bg2", parent => bg2,
     self_flex  =>
      (expand_w => (behavior => max), expand_h => (behavior => max),
       others   => <>),
     child_flex =>
      (dir => left_right, gap_c => (pixel, 15), others => <>),
     bgd        => HAL.Bitmap.Green);

     child_of_green1 : Widget.Any_Acc :=
   Widget.Create
    (id         => "child_of_green1", parent => ch1_bg2, priority => 3,
     self_flex  =>
      (expand_w => (pixel, 30), expand_h => (pixel, 30),
       others   => <>),
     child_flex =>
      (dir => left_right, others => <>),
     bgd        => HAL.Bitmap.Brown);

     child_of_green2 : Widget.Any_Acc :=
   Widget.Create
    (id         => "child_of_green2", parent => ch1_bg2, priority => 1,
     self_flex  =>
      (expand_w => (pixel, 30), expand_h => (pixel, 30),
       others   => <>),
     child_flex =>
      (dir => left_right, others => <>),
     bgd        => HAL.Bitmap.White);

     child_of_green3 : Widget.Any_Acc :=
   Widget.Create
    (id         => "child_of_green3", parent => ch1_bg2, priority => 0,
     self_flex  =>
      (expand_w => (pixel, 30), expand_h => (pixel, 30),
       others   => <>),
     child_flex =>
      (dir => left_right, others => <>),
     bgd        => HAL.Bitmap.Blue);

     child_of_green4 : Widget.Any_Acc :=
   Widget.Create
    (id         => "child_of_green4", parent => ch1_bg2, priority => 5,
     self_flex  =>
      (expand_w => (pixel, 30), expand_h => (pixel, 30),
       others   => <>),
     child_flex =>
      (dir => left_right, others => <>),
     bgd        => HAL.Bitmap.Purple);

     ch2_bg2 : Widget.Any_Acc :=
   Widget.Create
    (id         => "ch2_bg2", parent => bg2,
     self_flex  =>
      (expand_w => (behavior => max), expand_h => (behavior => max),
       others   => <>),
     child_flex =>
      (dir => left_right, align => bottom, others => <>),
     bgd        => HAL.Bitmap.Pink);

     content_wid : Widget.Any_Acc :=
   Widget.Create
    (id         => "content_wid", parent => ch2_bg2,
     self_flex  =>
      (expand_w => (behavior => content), expand_h => (behavior => content),
       others   => <>),
     child_flex =>
      (dir => left_right, others => <>),
     bgd        => HAL.Bitmap.Yellow);

     child_of_pink1 : Widget.Any_Acc :=
   Widget.Create
    (id         => "child_of_pink1", parent => content_wid,
     self_flex  =>
      (expand_w => (pixel, 55), expand_h => (pixel, 30),
       others   => <>),
     child_flex =>
      (dir => left_right, others => <>),
     bgd        => HAL.Bitmap.Brown);

     child_of_pink2 : Widget.Any_Acc :=
   Widget.Create
    (id         => "child_of_pink2", parent => content_wid,
     self_flex  =>
      (expand_w => (pixel, 30), expand_h => (pixel, 60),
       others   => <>),
     child_flex =>
      (dir => left_right, others => <>),
     bgd        => HAL.Bitmap.White);

     child_of_pink3 : Widget.Any_Acc :=
   Widget.Create
    (id         => "child_of_pink3", parent => content_wid,
     self_flex  =>
      (expand_w => (pixel, 30), expand_h => (pixel, 30),
       others   => <>),
     child_flex =>
      (dir => left_right, others => <>),
     bgd        => HAL.Bitmap.Blue);

     child_of_pink4 : Widget.Any_Acc :=
   Widget.Create
    (id         => "child_of_pink4", parent => content_wid,
     self_flex  =>
      (expand_w => (pixel, 30), expand_h => (pixel, 30),
       others   => <>),
     child_flex =>
      (dir => left_right, others => <>),
     bgd        => HAL.Bitmap.Purple);

     align_button : Widget.Any_Acc :=
   Widget.Button.Switch.Create
    (id        => "a", parent => child2, text => "Align", target => ch2_bg1,
     self_flex =>
      (expand_w => (pixel, 50), expand_h => (pixel, 50), others => <>),
     bgd       => HAL.Bitmap.Cyan);

     buoy_button : Widget.Any_Acc :=
   Widget.Button.Buoy.Create
    (id        => "b", parent => child2, text => "Buoy", target => ch2_bg1,
     self_flex =>
      (expand_w => (pixel, 50), expand_h => (pixel, 50), others => <>),
     bgd       => HAL.Bitmap.Cyan);

begin

    dui.render (STM32.Board.Display.Width, STM32.Board.Display.Height);

end kd_static;