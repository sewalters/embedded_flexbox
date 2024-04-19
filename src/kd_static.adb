with dui;              use dui;
with Widget;           use Widget;
with Widget.Text;      use Widget.Text;
with Widget.Image;     use Widget.Image;
with Widget.Button;    use Widget.Button;
with Widget.Button.Switch; use Widget.Button.Switch;
with Widget.Button.Buoy; use Widget.Button.Buoy;
with Widget.Button.Dir; use Widget.Button.Dir;
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
      (dir => top_bottom, others => <>),
     bgd        => HAL.Bitmap.Pink);

      button_hold : Widget.Any_Acc :=
   Widget.Create
    (id         => "button holder", parent => bg1,
     self_flex  =>
      (expand_w => (behavior => max), expand_h => (pixel, 50),
       others   => <>),
     child_flex =>
      (dir => left_right, others => <>),
     bgd        => HAL.Bitmap.Cyan);

      widg_hold : Widget.Any_Acc :=
   Widget.Create
    (id         => "button holder", parent => bg1,
     self_flex  =>
      (expand_w => (behavior => max), expand_h => (behavior => max),
       others   => <>),
     child_flex =>
      (dir => left_right, buoy => space_around, align => center, others => <>),
     bgd        => HAL.Bitmap.Dark_Grey);

     child_of_red1 : Widget.Any_Acc :=
   Widget.Create
    (id         => "child_of_red1", parent => widg_hold,
     self_flex  =>
      (expand_w => (pixel, 30), expand_h => (pixel, 30),
       others   => <>),
     child_flex =>
      (dir => left_right, others => <>),
     bgd        => HAL.Bitmap.Brown);

     child_of_red2 : Widget.Any_Acc :=
   Widget.Create
    (id         => "child_of_red2", parent => widg_hold,
     self_flex  =>
      (expand_w => (pixel, 30), expand_h => (pixel, 30),
       others   => <>),
     child_flex =>
      (dir => left_right, others => <>),
     bgd        => HAL.Bitmap.White);

     child_of_red3 : Widget.Any_Acc :=
   Widget.Create
    (id         => "child_of_red3", parent => widg_hold,
     self_flex  =>
      (expand_w => (pixel, 30), expand_h => (pixel, 30),
       others   => <>),
     child_flex =>
      (dir => left_right, others => <>),
     bgd        => HAL.Bitmap.Blue);

     child_of_red4 : Widget.Any_Acc :=
   Widget.Create
    (id         => "child_of_red4", parent => widg_hold,
     self_flex  =>
      (expand_w => (pixel, 30), expand_h => (pixel, 30),
       others   => <>),
     child_flex =>
      (dir => left_right, others => <>),
     bgd        => HAL.Bitmap.Red);

     align_button : Widget.Any_Acc :=
   Widget.Button.Switch.Create
    (id        => "a", parent => button_hold, text => "Alignment", target => widg_hold,
     self_flex =>
      (expand_w => (behavior => max), expand_h => (behavior => max), others => <>),
     bgd       => HAL.Bitmap.Dark_Green);

     buoy_button : Widget.Any_Acc :=
   Widget.Button.Buoy.Create
    (id        => "b", parent => button_hold, text => "Buoyancy", target => widg_hold,
     self_flex =>
      (expand_w => (behavior => max), expand_h => (behavior => max), others => <>),
     bgd       => HAL.Bitmap.Dark_Blue);

     dir_button : Widget.Any_Acc :=
   Widget.Button.Dir.Create
    (id        => "b", parent => button_hold, text => "Direction", target => widg_hold,
     self_flex =>
      (expand_w => (behavior => max), expand_h => (behavior => max), others => <>),
     bgd       => HAL.Bitmap.Dark_Red);

begin

    dui.render (STM32.Board.Display.Width, STM32.Board.Display.Height);

end kd_static;