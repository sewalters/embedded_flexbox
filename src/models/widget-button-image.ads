with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Hal.Bitmap; use Hal.Bitmap;
with Widget.Text; use Widget.Text;
with Widget.Image; use Widget.Image;

package Widget.Button.Image is

   subtype Parent is Widget.Button.Instance;

   type Instance is new Parent
   with record
      
      target: Widget.Any_Acc;
   end record;

   function Create (id            : string;
                    parent        : Widget.Any_Acc;
                    target        : Widget.Any_Acc;
                    text          : string := "";
                    overflow_text : text_overflow := truncate;
                    self_flex     : flex_t  := default_flex;
                    child_flex    : flex_t  := default_flex;
                    min_height, min_width : Natural := 0;
                    max_height, max_width : Natural := Natural'Last;
                    priority      : Natural := 0;
                    bgd           : Bitmap_Color) return Widget.Any_Acc;

   overriding
   procedure release_click(This: in out Instance);

   procedure switch_image(This: in out instance);
   
end Widget.Button.Image;