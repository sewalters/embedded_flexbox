with Widget;           use Widget;
with Widget.Text;      use Widget.Text;
with Widget.Button;    use Widget.Button;
with HAL.Bitmap;       use HAL.Bitmap;
with Ada.Finalization; use Ada.Finalization;
with STM32.Board;      use STM32.Board;
with Widget.Image;            use Widget.Image;
with Bitmapped_Drawing;
with dui;                     use dui;
with HAL;                     use HAL;
with Bitmap_Color_Conversion; use Bitmap_Color_Conversion;
procedure Report_GUI is

  
  header : Widget.Any_Acc :=
   Widget.Create
    (id         => "header", parent => dui.main_widget,
     self_flex  =>
      (expand_w => (behavior => max), expand_h => (pixel, 30), others => <>),
     child_flex => (dir => left_right, buoy => space_nothing,  others => <>), bgd => HAL.Bitmap.Dark_Grey);
   b1 : Widget.Any_Acc :=
      Widget.Button.Create
      (id        => "B1", parent => header, text => "Button 1",
      self_flex =>
         (expand_w => (pixel, 100), expand_h => (behavior => max), others => <>), bgd => HAL.Bitmap.Blue);
   b2 : Widget.Any_Acc :=
      Widget.Button.Create
      (id        => "B2", parent => header, text => "Button 2",
      self_flex =>
         (expand_w => (pixel, 100), expand_h => (behavior => max), others => <>), bgd => HAL.Bitmap.Blue_Violet);
   b3 : Widget.Any_Acc :=
      Widget.Button.Create
      (id        => "B3", parent => header, text => "Button 3",
      self_flex =>
         (expand_w => (pixel, 100), expand_h => (behavior => max), others => <>), bgd => HAL.Bitmap.Sky_Blue);
  header2 : Widget.Any_Acc :=
   Widget.Create
    (id         => "header2", parent => dui.main_widget,
     self_flex  =>
      (expand_w => (behavior => max), expand_h => (behavior => max), others => <>),
     child_flex => (dir => left_right, buoy => space_nothing,  others => <>), bgd => HAL.Bitmap.White);
  w1 : Widget.Any_Acc :=
   Widget.Create
    (id         => "w1", parent => header2,
     self_flex  =>
      (expand_w => (pixel, 100), expand_h => (behavior => max), others => <>),
     child_flex => (dir => top_bottom, buoy => space_nothing,  others => <>), bgd => HAL.Bitmap.Light_Grey);
  w2 : Widget.Any_Acc :=
   Widget.Create
    (id         => "w2", parent => header2,
     self_flex  =>
      (expand_w => (behavior => max), expand_h => (behavior => max), others => <>),
     child_flex => (dir => left_right, buoy => space_nothing,  others => <>), bgd => HAL.Bitmap.Brown);
  w3 : Widget.Any_Acc :=
   Widget.Create
    (id         => "w3", parent => header2,
     self_flex  =>
      (expand_w => (pixel, 100), expand_h => (behavior => max), others => <>),
     child_flex => (dir => left_right, buoy => space_nothing,  others => <>), bgd => HAL.Bitmap.Light_Grey);
  im_example    : Widget.Any_Acc :=
   Widget.Image.Create
    (id         => "IM", parent => w2, image => "Ada",
     self_flex  =>
      (expand_w => (behavior => max), expand_h => (behavior => max), others => <>),
     child_flex => (dir => left_right,  others => <>),
     bgd        => HAL.Bitmap.Green);
   text_example : Widget.Any_Acc :=
      Widget.Text.Create
      (id        => "Text", parent => w3, text => "Hello",
      self_flex =>
         (expand_w => (behavior => max), expand_h => (behavior => max), others => <>));
   bt_example1 : Widget.Any_Acc :=
      Widget.Button.Create
      (id        => "BT1", parent => w1, text => "Button 4",
      self_flex =>
         (expand_w => (behavior => max), expand_h => (pixel, 30), others => <>), bgd => HAL.Bitmap.Red);
   bt_example2 : Widget.Any_Acc :=
      Widget.Button.Create
      (id        => "BT2", parent => w1, text => "Button 5",
      self_flex =>
         (expand_w => (behavior => max), expand_h => (pixel, 30), others => <>), bgd => HAL.Bitmap.Dark_Red);
   bt_example3 : Widget.Any_Acc :=
      Widget.Button.Create
      (id        => "BT3", parent => w1, text => "Button 6",
      self_flex =>
         (expand_w => (behavior => max), expand_h => (pixel, 30), others => <>), bgd => HAL.Bitmap.Pale_Violet_Red);
begin
  --  stm32.Board.Display.Hidden_Buffer(1).Set_Source(HAL.Bitmap.Red);
  --  stm32.Board.Display.Hidden_Buffer(1).Fill_Rect(Area => ( Position => (0, 0), Width => 10, Height => 10));
  --  stm32.Board.Display.Update_Layers;
  dui.render (STM32.Board.Display.Width, STM32.Board.Display.Height);

end Report_GUI;
