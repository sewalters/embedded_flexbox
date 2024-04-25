with dui;                     use dui;

with Widget;                  use Widget;
with Widget.Text;             use Widget.Text;
with Widget.Image;            use Widget.Image;
with Widget.Button;           use Widget.Button;
with Widget.Key;              use Widget.Key;

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

procedure Typewriter is

  canvas : Widget.Any_Acc := Widget.Create(id => "canvas", 
            parent => dui.main_widget, 
            self_flex => (expand_w => (behavior => max), expand_h => (portion , 3) , others => <>),child_flex => (dir => left_right, others => <>), bgd => Hal.Bitmap.Navajo_White);
  canvas_text : Widget.Any_Acc := Widget.Text.Create(id => "canvas_text", text => "", font => Font16x24, parent => canvas, self_flex => (expand_w => (behavior => max), expand_h => (behavior => max), others => <>), overflow => wrap, fgd => Hal.bitmap.black, text_spacing => (pixel , 2));

  keyboard_background : Widget.Any_Acc := Widget.Create(id => "keyboard_background", 
            parent => dui.main_widget, 
            self_flex => (expand_w => (behavior => max), expand_h => (portion , 2) , others => <>),child_flex => (dir => top_bottom, align => center, buoy => space_evenly, others => <>), bgd => Hal.Bitmap.Dark_Grey);
  keyboard_row1 : Widget.Any_Acc := Widget.Create(id => "keyboard_row1", 
            parent => keyboard_background, 
            self_flex => (expand_w => (pixel, 460), expand_h => (pixel, 30) , others => <>),child_flex => (dir => left_right,buoy => space_evenly, others => <>), bgd => Hal.Bitmap.Dark_Grey);
  keyboard_row2 : Widget.Any_Acc := Widget.Create(id => "keyboard_row2", 
            parent => keyboard_background, 
            self_flex => (expand_w => (pixel, 460), expand_h => (pixel, 30) , others => <>),child_flex => (dir => left_right,buoy => space_evenly, others => <>), bgd => Hal.Bitmap.Dark_Grey);
  keyboard_row3 : Widget.Any_Acc := Widget.Create(id => "keyboard_row3", 
            parent => keyboard_background, 
            self_flex => (expand_w => (pixel, 460), expand_h => (pixel, 30) , others => <>),child_flex => (dir => left_right,buoy => space_evenly, others => <>), bgd => Hal.Bitmap.Dark_Grey);
  

  key_1 : Widget.Any_Acc := Widget.Key.Create(id => "key_1", parent => keyboard_row1,target => canvas_text, text => "1", font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_2 : Widget.Any_Acc := Widget.Key.Create(id => "key_2", parent => keyboard_row1,text => "2",target => canvas_text, font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_3 : Widget.Any_Acc := Widget.Key.Create(id => "key_3", parent => keyboard_row1,text => "3",target => canvas_text, font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_4 : Widget.Any_Acc := Widget.Key.Create(id => "key_4", parent => keyboard_row1,text => "4",target => canvas_text, font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_5 : Widget.Any_Acc := Widget.Key.Create(id => "key_5", parent => keyboard_row1,text => "5",target => canvas_text, font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_6 : Widget.Any_Acc := Widget.Key.Create(id => "key_6", parent => keyboard_row1,text => "6",target => canvas_text, font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_7 : Widget.Any_Acc := Widget.Key.Create(id => "key_7", parent => keyboard_row1,text => "7",target => canvas_text, font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_8 : Widget.Any_Acc := Widget.Key.Create(id => "key_8", parent => keyboard_row1,text => "8",target => canvas_text, font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_9 : Widget.Any_Acc := Widget.Key.Create(id => "key_9", parent => keyboard_row1,text => "9", target => canvas_text,font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_0 : Widget.Any_Acc := Widget.Key.Create(id => "key_0", parent => keyboard_row1,text => "0",target => canvas_text, font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_space : Widget.Any_Acc := Widget.Key.Create(id => "space", parent => keyboard_row1,text => " ",target => canvas_text, font => Font16x24, self_flex => (expand_w => (pixel, 100), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  
  key_a : Widget.Any_Acc := Widget.Key.Create(id => "key_a", parent => keyboard_row2,target => canvas_text,text => "a", font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_b : Widget.Any_Acc := Widget.Key.Create(id => "key_b", parent => keyboard_row2,target => canvas_text,text => "b", font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_c : Widget.Any_Acc := Widget.Key.Create(id => "key_c", parent => keyboard_row2,target => canvas_text,text => "c", font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_d : Widget.Any_Acc := Widget.Key.Create(id => "key_d", parent => keyboard_row2,target => canvas_text,text => "d", font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_e : Widget.Any_Acc := Widget.Key.Create(id => "key_e", parent => keyboard_row2,target => canvas_text,text => "e", font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_f : Widget.Any_Acc := Widget.Key.Create(id => "key_f", parent => keyboard_row2,target => canvas_text,text => "f", font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_g : Widget.Any_Acc := Widget.Key.Create(id => "key_g", parent => keyboard_row2,target => canvas_text,text => "g", font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_h : Widget.Any_Acc := Widget.Key.Create(id => "key_h", parent => keyboard_row2,target => canvas_text,text => "h", font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_i : Widget.Any_Acc := Widget.Key.Create(id => "key_i", parent => keyboard_row2,target => canvas_text,text => "i", font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_j : Widget.Any_Acc := Widget.Key.Create(id => "key_j", parent => keyboard_row2,target => canvas_text,text => "j", font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_k : Widget.Any_Acc := Widget.Key.Create(id => "key_k", parent => keyboard_row2,target => canvas_text,text => "k", font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_l : Widget.Any_Acc := Widget.Key.Create(id => "key_l", parent => keyboard_row2,target => canvas_text,text => "l", font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_m : Widget.Any_Acc := Widget.Key.Create(id => "key_m", parent => keyboard_row2,target => canvas_text,text => "m", font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);


  key_n : Widget.Any_Acc := Widget.Key.Create(id => "key_n", parent => keyboard_row3,target => canvas_text,text => "n", font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_o : Widget.Any_Acc := Widget.Key.Create(id => "key_o", parent => keyboard_row3,target => canvas_text,text => "o", font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_p : Widget.Any_Acc := Widget.Key.Create(id => "key_p", parent => keyboard_row3,target => canvas_text,text => "p", font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_q : Widget.Any_Acc := Widget.Key.Create(id => "key_q", parent => keyboard_row3,target => canvas_text,text => "q", font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_r : Widget.Any_Acc := Widget.Key.Create(id => "key_r", parent => keyboard_row3,target => canvas_text,text => "r", font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_s : Widget.Any_Acc := Widget.Key.Create(id => "key_s", parent => keyboard_row3,target => canvas_text,text => "s", font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_t : Widget.Any_Acc := Widget.Key.Create(id => "key_t", parent => keyboard_row3,target => canvas_text,text => "t", font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_u : Widget.Any_Acc := Widget.Key.Create(id => "key_u", parent => keyboard_row3,target => canvas_text,text => "u", font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_v : Widget.Any_Acc := Widget.Key.Create(id => "key_v", parent => keyboard_row3,target => canvas_text,text => "v", font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_w : Widget.Any_Acc := Widget.Key.Create(id => "key_w", parent => keyboard_row3,target => canvas_text,text => "w", font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_x : Widget.Any_Acc := Widget.Key.Create(id => "key_x", parent => keyboard_row3,target => canvas_text,text => "x", font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_y : Widget.Any_Acc := Widget.Key.Create(id => "key_y", parent => keyboard_row3,target => canvas_text,text => "y", font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  key_z : Widget.Any_Acc := Widget.Key.Create(id => "key_z", parent => keyboard_row3,target => canvas_text,text => "z", font => Font16x24, self_flex => (expand_w => (pixel, 30), expand_h => (pixel, 30), others => <>), bgd => hal.Bitmap.Black);
  
begin

   dui.render (STM32.Board.Display.Width, STM32.Board.Display.Height);

end Typewriter;
