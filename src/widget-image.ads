with Ada.Strings.Unbounded;
with Textures;  use Textures;
with Hal.Bitmap; use Hal.Bitmap;
with HAL; use HAL;
with Bitmap_Color_Conversion; use Bitmap_Color_Conversion;

with Ada.Finalization;
package Widget.Image is
    package asu renames Ada.Strings.Unbounded;

    subtype Parent is Widget.Instance;

    type Instance is new Parent with 
    record
        image        : Ada.Strings.Unbounded.Unbounded_String;
    end record;

    subtype Class is Instance'Class;

    type Acc is access all Instance;
    type Any_Acc is access all Class;

    function Create (id            : string;
                     parent        : Widget.Any_Acc;
                     image  : string;
                     self_flex     : flex_t  := default_flex;
                     child_flex    : flex_t  := default_flex;
                     min_height, min_width : Natural := 0;
                     max_height, max_width : Natural := Natural'Last;
                     bgd           : Bitmap_Color) return Widget.Any_Acc;


    --overriding procedure Event (This : in out Instance; Evt : Event_Kind);
    overriding procedure Draw (This : in out Instance; img : in out Bitmap_Buffer'Class);
    --overriding procedure Click (This : in out Instance);

private

    subtype Dispatch is Instance'Class;

end Widget.Image;