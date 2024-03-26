with Ada.Strings.Unbounded;
with Hal.Bitmap; use Hal.Bitmap;

package Widget.Scroll is
    type state_enum is (idle, clicking);
    type state_colors is array (state_enum) of Bitmap_Color;

    subtype Parent is Widget.Instance;

    type Instance is new Parent with 
    record
      state  : state_enum := idle;
      colors : state_colors := (idle     => HAL.Bitmap.Gray,
                                clicking => HAL.Bitmap.White);
      new_pw : Any_Acc;
    end record;

    subtype Class is Instance'Class;

    type Acc is access all Instance;
    type Any_Acc is access all Class;

    function Create (id            : string;
                     parent        : Widget.Any_Acc;
                     self_flex     : flex_t  := default_flex;
                     child_flex    : flex_t  := default_flex;
                     min_height, min_width : Natural := 0;
                     max_height, max_width : Natural := Natural'Last;
                     bgd           : Bitmap_Color) return Widget.Any_Acc;

   overriding 
   procedure Click (This: in out Instance);

   overriding
   procedure Draw (This : in out Instance; img : in out Bitmap_Buffer'Class);
   
   overriding
   function Is_Clickable(This: in Instance) return Boolean;

   procedure release_click(This: in out Instance);

private

    subtype Dispatch is Instance'Class;

end Widget.Scroll;