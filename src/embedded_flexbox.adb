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
with embedded_view; use embedded_view;
with dui;                     use dui;
with HAL;                     use HAL;
with Bitmap_Color_Conversion; use Bitmap_Color_Conversion;
with event_handler;

procedure Embedded_Flexbox is
   header  : Widget.Any_Acc :=
     Widget.Button.Create
       (id         => "header1", parent => dui.main_widget,
        self_flex  =>
          (expand_w => (pixel, 200), expand_h => (pixel, 200),
           others   => <>),
        child_flex => (dir => top_bottom, buoy => space_around, others => <>),
        bgd        => HAL.Bitmap.Red);
   headerb  : Widget.Any_Acc :=
     Widget.Create
       (id         => "headerb", parent => header,
        self_flex  =>
          (expand_w => (pixel, 200), expand_h => (pixel, 200),
           others   => <>),
        child_flex => (dir => top_bottom, others => <>),
        bgd        => HAL.Bitmap.Cyan);
   header2 : Widget.Any_Acc :=
     Widget.Create
       (id         => "header2", parent => headerb,
        self_flex  =>
          (expand_w => (pixel, 40), expand_h => (pixel, 40),
           others   => <>),
        child_flex => (dir => left_right, buoy => space_around, others => <>),
        priority => 10,
        bgd        => HAL.Bitmap.Purple);
   header3 : Widget.Any_Acc :=
     Widget.Create
       (id         => "header3", parent => headerb,
        self_flex  =>
          (expand_w => (pixel, 100), expand_h => (pixel, 60),
           others   => <>),
        child_flex => (dir => left_right, buoy => space_around, others => <>),
        priority => 5,
        bgd        => HAL.Bitmap.Blue);
   header4 : Widget.Any_Acc :=
     Widget.Button.Create
       (id         => "header4", parent => headerb,
        self_flex  =>
          (expand_w => (pixel, 40), expand_h => (pixel, 40),
           others   => <>),
        child_flex => (dir => left_right, buoy => space_around, others => <>),
        bgd        => HAL.Bitmap.Black);
   --head_t1 : Widget.Any_Acc := Widget.Text.Create(id => "textb", parent => headerb, text => "1st inserted, prio 0.");
   head_t2 : Widget.Any_Acc := Widget.Text.Create(id => "text2", parent => header2, text => "2nd inserted, prio 10.");
   head_t3 : Widget.Any_Acc := Widget.Text.Create(id => "text3", parent => header3, text => "3rd inserted, prio 5.");
   head_t4 : Widget.Any_Acc := Widget.Text.Create(id => "text4", parent => header4, text => "4th inserted, prio 0.");
begin

   dui.render (STM32.Board.Display.Width, STM32.Board.Display.Height);

end Embedded_Flexbox;
