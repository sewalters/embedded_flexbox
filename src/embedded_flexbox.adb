with Widget;           use Widget;
with Widget.Text;      use Widget.Text;
with Widget.Button;    use Widget.Button;
with HAL.Bitmap;       use HAL.Bitmap;
with Ada.Finalization; use Ada.Finalization;
with STM32.Board;      use STM32.Board;
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
      (expand_w => (behavior => max), expand_h => (behavior => max), others => <>),
     child_flex => (dir => top_bottom, buoy => space_around, others => <>), bgd => HAL.Bitmap.Red);
--    header2    : Widget.Any_Acc :=
--     Widget.Create
--      (id         => "header", parent => header,
--       self_flex  =>
--        (expand_w => (pixel, 50), expand_h => (pixel, 30), align => right, others => <>),
--       child_flex => (dir => left_right,  others => <>),
--       bgd        => HAL.Bitmap.Green);
--    header3    : Widget.Any_Acc :=
--     Widget.Create
--      (id         => "header", parent => header,
--       self_flex  =>
--        (expand_w => (pixel, 50), expand_h => (pixel, 30), others => <>),
--       child_flex => (dir => left_right,  others => <>),
--       bgd        => HAL.Bitmap.Blue);
--     text_example : Widget.Any_Acc :=
--        Widget.Text.Create
--        (id        => "Text", parent => header, text => "Example text", overflow => wrap,
--        self_flex =>
--           (expand_w => (behavior => max), expand_h => (pixel, 50), others => <>));
   bt_example : Widget.Any_Acc :=
      Widget.Button.Create
      (id        => "BT", parent => header, text => "Button",
      self_flex =>
         (expand_w => (pixel, 150), expand_h => (pixel, 100), others => <>), bgd => HAL.Bitmap.Purple);
   bt_example2 : Widget.Any_Acc :=
      Widget.Button.Create
      (id        => "BT", parent => header, text => "Button",
      self_flex =>
         (expand_w => (pixel, 150), expand_h => (pixel ,100), others => <>), bgd => HAL.Bitmap.Blue);
--    im_example    : Widget.Any_Acc :=
--     Widget.Image.Create
--      (id         => "IM", parent => header, image => "Ada",
--       self_flex  =>
--        (expand_w => (pixel, 128), expand_h => (pixel, 128), others => <>),
--       child_flex => (dir => left_right,  others => <>),
--       bgd        => HAL.Bitmap.Green);
begin

  dui.render (STM32.Board.Display.Width, STM32.Board.Display.Height);

end Embedded_Flexbox;
