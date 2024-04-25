with dui;                     use dui;

with Widget;                  use Widget;
with Widget.Text;             use Widget.Text;
with Widget.Image;            use Widget.Image;
with Widget.Button;           use Widget.Button;
with Widget.Button.Image;     use Widget.Button.Image;

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

procedure Image_Gallery is
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

     im_left   : Widget.Any_Acc :=
     Widget.Image.Create
       (id         => "IM", parent => image_hold, image => "spark",
        self_flex  =>
          (expand_w => (pixel, 75), expand_h => (pixel, 75),
           others   => <>),
        child_flex => (dir => left_right, others => <>),
        bgd        => HAL.Bitmap.Green);

     im_example   : Widget.Any_Acc :=
     Widget.Image.Create
       (id         => "IM", parent => image_hold, image => "ada",
        self_flex  =>
          (expand_w => (pixel, 150), expand_h => (pixel, 150),
           others   => <>),
        child_flex => (dir => left_right, others => <>),
        bgd        => HAL.Bitmap.Green);

        im_right   : Widget.Any_Acc :=
     Widget.Image.Create
       (id         => "IM", parent => image_hold, image => "psu_shield",
        self_flex  =>
          (expand_w => (pixel, 75), expand_h => (pixel, 75),
           others   => <>),
        child_flex => (dir => left_right, others => <>),
        bgd        => HAL.Bitmap.Green);

        text_hold : Widget.Any_Acc :=
   Widget.Create
    (id         => "header", parent => header,
     self_flex  =>
      (expand_w => (behavior => max), expand_h => (pixel, 50),
       others   => <>),
     child_flex =>
      (dir => left_right, buoy => space_around, others => <>),
     bgd        => HAL.Bitmap.Grey);

     widg : Widget.Any_Acc :=
   Widget.Create
    (id         => "header", parent => text_hold,
     self_flex  =>
      (expand_w => (pixel, 200), expand_h => (pixel, 50),
       others   => <>),
     child_flex =>
      (dir => left_right, others => <>),
     bgd        => HAL.Bitmap.Grey);

     text_example : Widget.Any_Acc :=
     Widget.Text.Create
       (id        => "Text", parent => text_hold, text => "Ada Logo",
        self_flex =>
          (expand_w => (behavior => max), expand_h => (behavior => max),
           others   => <>));

    image_button : Widget.Any_Acc :=
   Widget.Button.Image.Create
    (id        => "a", parent => header, text => "Change Me", target => im_example, image_left => im_left, image_right => im_right, gallery_text => text_example,
     self_flex =>
      (expand_w => (behavior => max), expand_h => (pixel, 60), others => <>),
     bgd       => HAL.Bitmap.Cyan);

begin

dui.render (STM32.Board.Display.Width, STM32.Board.Display.Height);

end Image_Gallery;