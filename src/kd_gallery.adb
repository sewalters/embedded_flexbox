with dui;              use dui;
with Widget;           use Widget;
with Widget.Text;      use Widget.Text;
with Widget.Image;     use Widget.Image;
with Widget.Button;    use Widget.Button;
with Widget.Button.Image; use Widget.Button.Image;
with HAL;              use HAL;
with HAL.Bitmap;       use HAL.Bitmap;
with Ada.Finalization; use Ada.Finalization;
with STM32.Board;      use STM32.Board;
with embedded_view;    use embedded_view;
with event_handler;

procedure kd_gallery is
header : Widget.Any_Acc :=
   Widget.Create
    (id         => "header", parent => dui.main_widget,
     self_flex  =>
      (expand_w => (behavior => max), expand_h => (behavior => max),
       others   => <>),
     child_flex =>
      (dir => top_bottom, align => center, others => <>),
     bgd        => HAL.Bitmap.Grey);

     image_hold : Widget.Any_Acc :=
   Widget.Create
    (id         => "header", parent => header,
     self_flex  =>
      (expand_w => (behavior => max), expand_h => (behavior => max),
       others   => <>),
     child_flex =>
      (dir => left_right, align => center, buoy => space_around, others => <>),
     bgd        => HAL.Bitmap.Grey);

     im_example   : Widget.Any_Acc :=
     Widget.Image.Create
       (id         => "IM", parent => image_hold, image => "Ada",
        self_flex  =>
          (expand_w => (pixel, 150), expand_h => (pixel, 150),
           others   => <>),
        child_flex => (dir => left_right, others => <>),
        bgd        => HAL.Bitmap.Green);

    image_button : Widget.Any_Acc :=
   Widget.Button.Image.Create
    (id        => "a", parent => header, text => "Change Me", target => im_example,
     self_flex =>
      (expand_w => (behavior => max), expand_h => (pixel, 50), others => <>),
     bgd       => HAL.Bitmap.Cyan);

begin

dui.render (STM32.Board.Display.Width, STM32.Board.Display.Height);

end kd_gallery;