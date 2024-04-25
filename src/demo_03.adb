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

procedure demo_03 is

  --   header       : Widget.Any_Acc :=
  --     Widget.Create
  --       (id         => "header", parent => dui.main_widget,
  --        self_flex  =>
  --          (expand_w => (behavior => max), expand_h => (pixel, 100),
  --           others   => <>),
  --        child_flex => (dir => left_right, buoy => space_nothing, others => <>),
  --        bgd        => HAL.Bitmap.Dark_Grey);
  --   text_example : Widget.Any_Acc :=
  --     Widget.Text.Create
  --       (id        => "Text", parent => header, text => "Hello hello hello hello hello",
  --        self_flex =>
  --          (expand_w => (behavior => max), expand_h => (behavior => max),
  --           others   => <>),
  --        overflow => wrap);

   header2      : Widget.Any_Acc :=
     Widget.Create
       (id         => "header2", parent => dui.main_widget,
        self_flex  =>
          (expand_w => (behavior => max), expand_h => (behavior => max),
           others   => <>),
        child_flex => (dir => left_right, buoy => space_nothing, others => <>),
        bgd        => HAL.Bitmap.White);
   w1           : Widget.Any_Acc :=
     Widget.Create
       (id         => "w1", parent => header2,
        self_flex  =>
          (expand_w => (pixel, 100), expand_h => (behavior => max),
           others   => <>),
        child_flex => (dir => top_bottom, buoy => space_nothing, align => right, others => <>),
        bgd        => HAL.Bitmap.Light_Grey);
   w2           : Widget.Any_Acc :=
     Widget.Create
       (id         => "w2", parent => header2,
        self_flex  =>
          (expand_w => (behavior => max), expand_h => (behavior => max),
           others   => <>),
        child_flex => (dir => left_right, buoy => space_evenly, others => <>),
        bgd        => HAL.Bitmap.Brown);
  --   w3           : Widget.Any_Acc :=
  --     Widget.Create
  --       (id         => "w3", parent => header2,
  --        self_flex  =>
  --          (expand_w => (pixel, 100), expand_h => (behavior => max),
  --           others   => <>),
  --        child_flex => (dir => top_bottom, buoy => space_nothing, others => <>),
  --        bgd        => HAL.Bitmap.Light_Grey);
   im_example1   : Widget.Any_Acc :=
     Widget.Image.Create
       (id         => "IM1", parent => w2, image => "Banana",
        self_flex  =>
          (expand_w => (pixel, 64), expand_h => (pixel, 64),
           others   => <>),
        child_flex => (dir => left_right, others => <>),
        bgd        => HAL.Bitmap.Green);
   im_example2   : Widget.Any_Acc :=
     Widget.Image.Create
       (id         => "IM2", parent => w2, image => "Banana",
        self_flex  =>
          (expand_w => (pixel, 64), expand_h => (pixel, 64),
           others   => <>),
        child_flex => (dir => left_right, others => <>),
        bgd        => HAL.Bitmap.Green);
   im_example3   : Widget.Any_Acc :=
     Widget.Image.Create
       (id         => "IM3", parent => w2, image => "Banana",
        self_flex  =>
          (expand_w => (pixel, 64), expand_h => (pixel, 64),
           others   => <>),
        child_flex => (dir => left_right, others => <>),
        bgd        => HAL.Bitmap.Green);
   b1           : Widget.Any_Acc :=
     Widget.Button.Create
       (id        => "B1", parent => w1, text => "B1",
        self_flex =>
          (expand_w => (pixel, 30), expand_h => (pixel, 30), align => left,
           others   => <>),
        bgd       => HAL.Bitmap.Blue);
   b2           : Widget.Any_Acc :=
     Widget.Button.Create
       (id        => "B2", parent => w1, text => "B2",
        self_flex =>
          (expand_w => (pixel, 30), expand_h => (pixel, 30),
           others   => <>),
        bgd       => HAL.Bitmap.Blue_Violet);
   b3           : Widget.Any_Acc :=
     Widget.Button.Create
       (id        => "B3", parent => w1, text => "B3",
        self_flex =>
          (expand_w => (pixel, 30), expand_h => (pixel, 30), align => left,
           others   => <>),
        bgd       => HAL.Bitmap.Sky_Blue);
   bt_example1  : Widget.Any_Acc :=
     Widget.Button.Create
       (id        => "BT1", parent => w1, text => "B4",
        self_flex =>
          (expand_w => (pixel, 30), expand_h => (pixel, 30),
           others   => <>),
        bgd       => HAL.Bitmap.Red);
   bt_example2  : Widget.Any_Acc :=
     Widget.Button.Create
       (id        => "BT2", parent => w1, text => "B5",
        self_flex =>
          (expand_w => (pixel, 30), expand_h => (pixel, 30), align => left,
           others   => <>),
        bgd       => HAL.Bitmap.Dark_Red);
   bt_example3  : Widget.Any_Acc :=
     Widget.Button.Create
       (id        => "BT3", parent => w1, text => "B6",
        self_flex =>
          (expand_w => (pixel, 30), expand_h => (pixel, 30),
           others   => <>),
        bgd       => HAL.Bitmap.Pale_Violet_Red);
begin

   dui.render (STM32.Board.Display.Width, STM32.Board.Display.Height);

end demo_03;
