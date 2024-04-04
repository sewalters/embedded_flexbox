with STM32.Board; use STM32.Board;
with HAL.Bitmap; use HAL.Bitmap;
package body event_handler is
    task body Generate_Event_Snapshot is
    begin
    STM32.Board.Display.Initialize;
    STM32.Board.Display.Initialize_Layer (1, HAL.Bitmap.ARGB_1555);
            STM32.Board.Display.Hidden_Buffer (1).Set_Source
               (HAL.Bitmap.blue);
            STM32.Board.Display.Hidden_Buffer (1).Fill_Rect
               (Area =>
                   (Position => (0, 0), Width => 50,
                    Height   => 50));
        STM32.Board.Display.Update_Layer(1);
    end;
end event_handler;