with STM32.Board; use STM32.Board;
with HAL.Bitmap; use HAL.Bitmap;
package body embedded_view is

    procedure refresh(window_width : Natural; window_height : Natural) is
    begin
        STM32.Board.Display.Hidden_Buffer (1).Set_Source (HAL.Bitmap.Black);
        STM32.Board.Display.Hidden_Buffer (1).Fill_Rect
           (Area =>
               (Position => (0, 0), Width => window_width,
                Height => window_height));
    end;
    procedure Draw_Buffer(window_width : Natural; window_height : Natural) is
    begin
        STM32.Board.Display.Update_Layer (1);
    end Draw_Buffer;

    function Get_Hidden_Buffer return Bitmap_Buffer'Class is
    begin
        return STM32.Board.Display.Hidden_Buffer (1).all;
    end Get_Hidden_Buffer;

begin
    STM32.Board.Display.Initialize;
    STM32.Board.Display.Initialize_Layer (1, HAL.Bitmap.ARGB_1555);
    STM32.Board.Touch_Panel.Initialize;
end embedded_view;
