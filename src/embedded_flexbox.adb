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
          (expand_w => (behavior => max), expand_h => (behavior => max),
           others   => <>),
        child_flex =>
          (dir    => top_bottom,
           others => <>),
        bgd        => HAL.Bitmap.Red);

   img1 : Widget.Any_Acc :=
     Widget.Image.Create
       (id        => "img1", parent => header, image => "Ada",
        self_flex =>
          (expand_w => (behavior => max), expand_h => (behavior => max),
           others   => <>), bgd => Hal.Bitmap.Black);

begin
   --  stm32.Board.Display.Hidden_Buffer(1).Set_Source(HAL.Bitmap.Red);
   --  stm32.Board.Display.Hidden_Buffer(1).Fill_Rect(Area => ( Position => (0, 0), Width => 10, Height => 10));
   --  stm32.Board.Display.Update_Layers;
   dui.render (STM32.Board.Display.Width, STM32.Board.Display.Height);

end Embedded_Flexbox;
