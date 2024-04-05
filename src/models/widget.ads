with Hal.Bitmap; use Hal.Bitmap;
with Ada.Strings.Unbounded;
with Ada.Finalization;
with Ada.Containers.Multiway_Trees;

package Widget is
    package SU renames Ada.Strings.Unbounded;

    function "+" (Source : in String) return SU.Unbounded_String is
        (SU.To_Unbounded_String (source));
    
    function "+" (Source : in SU.Unbounded_String) return String is
        (SU.To_String (source));

   type percent_t is new Float range 0.0 .. 1.0;

   type dir_t      is (left_right, right_left, top_bottom, bottom_top, front_back, back_front);
   type align_t    is (top, right, bottom, left, center, stretch);
   type buoy_t     is (space_between, space_around, space_evenly, space_nothing);
   type behavior_t is (content, portion, pixel, percent, max);

   type expand_t (behavior : behavior_t := max) is record
      case behavior is
         --when content =>
         --   content : Positive;
         when portion =>
            portion : Positive;
         when pixel =>
            pixel : Positive;
         when percent =>
            percent : percent_t;
         when others =>
            null;
      end case;
   end record;

   type gap_t (behavior : behavior_t := max) is record
      case behavior is
         when pixel =>
            pixel : Natural;
         when percent =>
            percent : percent_t;
         when others =>
            null;
      end case;
   end record;

   type flex_t is record
      dir      : dir_t    := left_right;
      align    : align_t  := top;
      buoy     : buoy_t   := space_nothing;
      expand_h : expand_t := (behavior => max);
      expand_w : expand_t := (behavior => max);
      gap_r : gap_t := (pixel, 0);
      gap_c : gap_t := (pixel, 0);
   end record;

   default_flex : flex_t := (others => <>);

   type Event_Kind is (Click_In, Click_Out, Hover);

   type Instance is new Ada.Finalization.Controlled with 
   record
      id         : SU.Unbounded_String;
      x, y       : Natural   := 0;
      w, h       : Natural   := 50;
      min_height, min_width : Natural := 0;
      max_height, max_width : Natural := Natural'Last;
      self_flex  : flex_t;
      child_flex : flex_t;
      priority   : Natural   := 0;
      bgd        : Bitmap_Color := (0, 0, 0, 0);
   end record;
   subtype Class is Instance'Class;

   type Acc is access all Instance;
   type Any_Acc is access all Class;

   

   function Create (id         : string;
                    parent     : Widget.Any_Acc;
                    self_flex  : flex_t  := default_flex;
                    child_flex : flex_t  := default_flex;
                    priority   : Natural := 0;
                    min_height, min_width : Natural := 0;
                    max_height, max_width : Natural := Natural'Last;
                    bgd        : Bitmap_Color) return Widget.Any_Acc;

   function Is_In_Bound (This : in out Instance; x_Input: Natural; y_Input : Natural) return Boolean;
   procedure Set_Width(This: in out Instance; calculated_width: Natural);
   procedure Set_Height(This: in out Instance; calculated_height: Natural);
   procedure Draw (This : in out Instance; img : in out Bitmap_Buffer'Class);
   procedure Click (This : in out Instance);
   function Is_Clickable(This: in Instance) return Boolean;
   procedure Set_Event_Override_Width(This: in out Instance; Parent: Widget.Any_Acc; new_width : Natural);
   procedure Set_Event_Override_Height(This: in out Instance; Parent: Widget.Any_Acc; new_height : Natural);
   function On_Boundary(This: in out Instance; x: Natural; y : Natural) return Boolean;

private

   

end Widget;
