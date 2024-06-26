with Ada.Strings.Unbounded;
with Hal.Bitmap; use Hal.Bitmap;
with Widget.Text; use Widget.Text;
with BMP_Fonts; use BMP_Fonts;

package Widget.Button is

   subtype Parent is Widget.Instance;

   type state_enum is (idle, hover, clicking);
   type state_colors is array (state_enum) of Bitmap_Color;

   type Instance is new Parent
   with record
      state  : state_enum := idle;
      colors : state_colors := (idle     => HAL.Bitmap.Gray,
                                hover    => HAL.Bitmap.Light_Grey,
                                clicking => HAL.Bitmap.White);
      button_text  : Widget.Text.Any_Acc;
   end record;
   
   subtype Class is Instance'Class;

   type Acc is access all Instance;
   type Any_Acc is access all Class;

   function Create (id            : string;
                    parent        : Widget.Any_Acc;
                    text          : string := "";
                    overflow_text : text_overflow := truncate;
                    font : BMP_Font := Font12x12;
                    self_flex     : flex_t  := default_flex;
                    child_flex    : flex_t  := default_flex;
                    min_height, min_width : Natural := 0;
                    max_height, max_width : Natural := Natural'Last;
                    priority      : Natural := 0;
                    bgd           : Bitmap_Color) return Widget.Any_Acc;

   overriding
   procedure Draw (This : in out Instance; img : in out Bitmap_Buffer'Class);

   overriding 
   procedure Click (This: in out Instance);
   
   overriding
   function Is_Clickable(This: in Instance) return Boolean;

   procedure release_click(This: in out Instance);

private
   
   subtype Dispatch is Instance'Class;
   
end Widget.Button;
