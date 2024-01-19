with Widget;           use Widget;
with HAL.Bitmap;       use HAL.Bitmap;
with Ada.Finalization; use Ada.Finalization;
with STM32.Board;
with Bitmapped_Drawing;
with dui;              use dui;
procedure Embedded_Flexbox is
   header  : Widget.Any_Acc :=
     Widget.Create
       (id         => "header", parent => dui.main_widget,
        self_flex  =>
          (expand_w => (behavior => max), expand_h => (pixel, 17),
           others   => <>),
        child_flex => (dir => left_right, buoy => space_evenly, others => <>),
        bgd        => Hal.Bitmap.Red);
   header2 : Widget.Any_Acc :=
     Widget.Create
       (id         => "header", parent => dui.main_widget,
        self_flex  =>
          (expand_w => (behavior => max), expand_h => (pixel, 30),
           others   => <>),
        child_flex => (dir => left_right, align => center, others => <>),
        bgd        => Hal.Bitmap.Green);
   lilguy  : Widget.Any_Acc :=
     Widget.Create
       (id         => "header", parent => header2,
        self_flex  =>
          (expand_w => (pixel, 50), expand_h => (pixel, 10),
           others   => <>),
        child_flex => (dir => left_right, others => <>),
        bgd        => Hal.Bitmap.Pink);
   lilguy2  : Widget.Any_Acc :=
     Widget.Create
       (id         => "header", parent => header2,
        self_flex  =>
          (expand_w => (pixel, 50), expand_h => (pixel, 10),
           others   => <>),
        child_flex => (dir => left_right, others => <>),
        bgd        => Hal.Bitmap.Purple);
   --  lilguy3  : Widget.Any_Acc :=
   --    Widget.Create
   --      (id         => "header", parent => header,
   --       self_flex  =>
   --         (expand_w => (pixel, 50), expand_h => (pixel, 50),
   --          others   => <>),
   --       child_flex => (dir => left_right, others => <>),
   --       bgd        => Hal.Bitmap.Magenta);
   header3 : Widget.Any_Acc :=
     Widget.Create
       (id         => "header", parent => dui.main_widget,
        self_flex  =>
          (expand_w => (behavior => max), expand_h => (pixel, 10),
           others   => <>),
        child_flex => (dir => left_right, others => <>),
        bgd        => Hal.Bitmap.Blue);
begin
   for i in 1 .. 2 loop
      STM32.Board.Display.Hidden_Buffer (1).Set_Source (HAL.Bitmap.Aqua_Marine);
      STM32.Board.Display.Hidden_Buffer (1).Fill_Rect(Area =>(Position => (50, 50), Width => 50,Height   => 50));
      STM32.Board.Display.Update_Layer(1);
   end loop;
   dui.render (STM32.Board.Display.Width, STM32.Board.Display.Height);
end Embedded_Flexbox;
