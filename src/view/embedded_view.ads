with Hal.Bitmap; use Hal.Bitmap;
package embedded_view is
    
    procedure refresh(window_width : Natural; window_height : Natural);
    procedure Draw_Buffer(window_width : Natural; window_height : Natural);
    function Get_Hidden_Buffer return Bitmap_Buffer'Class;
end embedded_view;