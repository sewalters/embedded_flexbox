with Ada.Strings.Unbounded;
with BMP_Fonts; use BMP_Fonts;

package Widget.Text is

   subtype Parent is Widget.Instance;

   type Instance is new Parent
   with record
      text          : Ada.Strings.Unbounded.Unbounded_String;
      font : BMP_Font;
      fgd    : Bitmap_Color := Hal.Bitmap.White;
      --bgd : Bitmap_Color := Hal.Bitmap.Black;
      magnification : natural := 2;
   end record;
   
   subtype Class is Instance'Class;

   type Acc is access all Instance;
   type Any_Acc is access all Class;

   function Create (id            : string;
                    parent        : Widget.Any_Acc;
                    text          : string;
                    font : BMP_Font := Font12x12;
                    self_flex     : flex_t  := default_flex;
                    child_flex    : flex_t  := default_flex;
                    min_height, min_width : Natural := 0;
                    max_height, max_width : Natural := Natural'Last;
                    fgd           : Bitmap_Color:= Hal.Bitmap.White;
                    bgd : Bitmap_Color:= Hal.Bitmap.Black) return Widget.Any_Acc;

   --  overriding
   --  procedure Event (This : in out Instance; Evt : Event_Kind);

   --  overriding 
   --  procedure Click (This: in out Instance);

   overriding
   procedure Draw (This : in out Instance; img : in out Bitmap_Buffer'Class);

private
   
   subtype Dispatch is Instance'Class;
   
end Widget.Text;