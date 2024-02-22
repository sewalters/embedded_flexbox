with Ada.Finalization;        use Ada.Finalization;
with Ada.Real_Time;           use Ada.Real_Time;
with Ada.Text_IO;             use Ada.Text_IO;
with STM32.Board;             use STM32.Board;
with HAL.Bitmap;              use HAL.Bitmap;
with HAL.Touch_Panel;         use HAL.Touch_Panel;
with BMP_Fonts;
with Bitmap_Color_Conversion; use Bitmap_Color_Conversion;
with HAL.Framebuffer;

--with font;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

--with importer; -- Removed, still compiled.

--with namespaces; use namespaces;

with Widget;
with Widget.Button;

package body dui is

    procedure add_to_LOT (Widget : Any_Acc; Parent : Any_Acc) is
    begin
        dui.LOT.Append_Child
           (dui.Layout_Object_Tree.Find (dui.LOT, Parent), Widget);
    end add_to_LOT;

    --  procedure draw_image
    --     (target : in out g.image; img : in out g.image_access; x, y : Natural;
    --      w, h   :        Natural)
    --  is
    --      it, jt : Integer;
    --  begin
    --      for j in img'Range (2) loop
    --          for i in img'Range (1) loop
    --              it := x + i;
    --              jt := y + j;
    --              if it <= x + w and jt <= y + h then
    --                   (it, jt) := img (i, j);
    --              end if;
    --          end loop;
    --      end loop;
    --  exception
    --      when others =>
    --          Put_Line ("ij: " & it'Image & " jt: " & jt'Image);
    --  end draw_image;

    --  procedure draw_rect
    --     (target : in out g.image; x, y : Natural; w, h : Natural; c : g.color)
    --  is
    --      Xb     : constant Integer := x;
    --      Xe     : constant Integer := x + w - 1;
    --      Yb     : constant Integer := y;
    --      Ye     : constant Integer := y + h - 1;
    --      Wx     : Integer          := Layout_Object_Tree.Element (LOT_Root).w;
    --      Wy     : Integer          := Layout_Object_Tree.Element (LOT_Root).h;
    --      ic, jc : Integer;
    --  begin
    --      --      Put_Line("Xb" & Natural'Image(Xb));
    --      --      Put_Line("Xe" & Natural'Image(Xe));
    --      --      Put_Line("Yb" & Natural'Image(Yb));
    --      --      Put_Line("Ye" & Natural'Image(Ye));
    --      for I in Xb .. Xe loop
    --          for J in Yb .. Ye loop
    --              ic := I;
    --              jc := J;
    --              if ((I < Wx and J < Wy) and ((I > 0) and (J > 0))) then
    --                  target (I, J) := c;
    --              end if;
    --          end loop;
    --      end loop;
    --  exception
    --      when others =>
    --          Put_Line ("i: " & ic'Image & " J: " & jc'Image);
    --  end draw_rect;

    --  procedure draw_character
    --     (c    : Character; magnification : Natural; target : in out g.image;
    --      x, y : Natural; color : g.color)
    --  is
    --      x_font : constant Integer := font.get_font_char_start (c);
    --      y_font : constant Integer := 1;
    --      use g;
    --  begin
    --      for fj in font.bitmap_height_t'First .. font.bitmap_base loop
    --          for fi in font.bitmap_width_t'First .. font.bitmap_base loop
    --              --Put_Line (font.font_1_img (x_font + fi - 1, y_font + fj - 1)'image);
    --              --Put_Line (g.color_val'last'image);
    --              if font.font_1_img (x_font + fi - 1, y_font + fj - 1) = g.white
    --              then
    --                  for mj in 1 .. magnification loop
    --                      for mi in 1 .. magnification loop
    --                          target
    --                             (x + (fi * magnification) + mi - 1,
    --                              y + (fj * magnification) + mj - 1) :=
    --                             color;
    --                      end loop;
    --                  end loop;
    --              end if;
    --          end loop;
    --      end loop;
    --  end draw_character;

    --  procedure draw_text
    --     (target : in out g.image; text : String; magnification : Natural;
    --      x, y   :        Natural; color : g.color)
    --  is
    --      use g;
    --  begin
    --      for c in text'Range loop
    --          declare
    --              i : Natural :=
    --                 x + (c - 1) * (magnification * (font.bitmap_base + 1));
    --              j : Natural := y;
    --          begin
    --              draw_character (text (c), magnification, target, i, j, color);
    --          end;
    --      end loop;
    --  exception
    --      when others =>
    --          Put_Line ("draw text problem!");
    --  end draw_text;

    -- need a pass from leaf to root to compute intrinsic, inner content width and height

    procedure render (window_width : Natural; window_height : Natural) is

        --      procedure debug_dui (c : Layout_Object_Tree.Cursor) is
        --          id : Unbounded_String := Layout_Object_Tree.Element (c).id;
        --          x  : Natural          := Layout_Object_Tree.Element (c).x;
        --          y  : Natural          := Layout_Object_Tree.Element (c).y;
        --          w  : Natural          := Layout_Object_Tree.Element (c).w;
        --          h  : Natural          := Layout_Object_Tree.Element (c).h;
        --      begin
        --          Put_Line ("Widget id: " & To_String (id));
        --          Put_Line ("x: " & Natural'Image (x));
        --          Put_Line ("y: " & Natural'Image (y));
        --          Put_Line ("width: " & Natural'Image (w));
        --          Put_Line ("height: " & Natural'Image (h));
        --          Put_Line ("");
        --      end debug_dui;

        procedure render_node is
            Curr_X : Natural := 0;
            Curr_Y : Natural := 0;
        begin

            for C in LOT.Iterate loop
                --declare
                --w : Widget.Any_Acc := Layout_Object_Tree.Element (c);
                begin
                    --480x272
                    --  if w.x < 0 or w.x > (480 - w.w) then
                    --      w.x := 0;
                    --  end if;
                    --  if w.y < 0 or w.y > (272 - w.h) then
                    --      w.y := 0;
                    --  end if;
                    Layout_Object_Tree.Element (c).Draw
                       (img => STM32.Board.Display.Hidden_Buffer (1).all);
                    --  STM32.Board.Display.Hidden_Buffer (1).Set_Source (w.bgd);
                    --  STM32.Board.Display.Hidden_Buffer (1).Fill_Rect
                    --     (Area =>
                    --         (Position => (w.x, w.y), Width => w.w,
                    --          Height   => w.h));
                end;
            end loop;
            declare
                State : constant TP_State :=
                   STM32.Board.Touch_Panel.Get_All_Touch_Points;
            begin

                STM32.Board.Display.Hidden_Buffer (1).Set_Source
                   (HAL.Bitmap.Green);

                if State'Length = 0 then
                    --null;
                    for C in LOT.Iterate loop
                        if Layout_Object_Tree.Element (C).Is_Clickable then
                            Widget.Button.Any_Acc
                               (Layout_Object_Tree.Element (c))
                               .release_click;
                        end if;
                    end loop;
                elsif State'Length = 1 then
                    Curr_X := State (State'First).X;
                    Curr_Y := State (State'First).Y;
                    --STM32.Board.Display.Hidden_Buffer (1).Fill_Rounded_Rect
                    --(((Curr_X, Curr_Y), 40, 40), 20);
                    for C in LOT.Iterate loop
                        if Layout_Object_Tree.Element (C).Is_In_Bound
                              (Curr_X, Curr_Y)
                        then
                            Layout_Object_Tree.Element (C).Click;
                        end if;
                    end loop;
                else
                    null;
                end if;

                if State'Length > 0 then
                    STM32.Board.Display.Update_Layer (1, Copy_Back => True);
                end if;
            end;
            STM32.Board.Display.Update_Layer (1);
        end render_node;

        --      procedure test (c : Layout_Object_Tree.Cursor) is
        --      begin
        --          if Layout_Object_Tree.Element (c).all in Loadable'Class then
        --              Loadable'Class (Layout_Object_Tree.Element (c).all).Load;
        --          end if;
        --      end test;

        procedure compute_node (c : Layout_Object_Tree.Cursor) is
            cc : Natural      := Natural (Layout_Object_Tree.Child_Count (c));
            LOT_Parent         : Widget.Class :=
               Layout_Object_Tree.Element (c).all; --parent
            LOT_pw             : Natural      := LOT_Parent.w; --parent width
            LOT_ph             : Natural      := LOT_Parent.h; --parent height
            LOT_ox : Natural      := LOT_Parent.x; --x offset for calculations
            LOT_oy : Natural      := LOT_Parent.y; --y offset for calculations
            child_row          : Boolean      :=
               (LOT_Parent.child_flex.dir = left_right or
                LOT_Parent.child_flex.dir = right_left);
            child_column       : Boolean      :=
               (LOT_Parent.child_flex.dir = top_bottom or
                LOT_Parent.child_flex.dir = bottom_top);
            child_depth        : Boolean      :=
               (LOT_Parent.child_flex.dir = front_back or
                LOT_Parent.child_flex.dir = back_front);
            buoy_wh            : buoy_t;
            align_wh           : align_t;
            gap_r, gap_c       : Natural;
            expand_w, expand_h : expand_t;
            width_pixel_left   : Natural      := LOT_Parent.w;
            height_pixel_left  : Natural      := LOT_Parent.h;
            total_portion      : Natural      := 0;
            nmbr_max           : Natural      := 0;

            procedure calculate_portions is
            begin
                --start by setting gap sizes for gap_c (column gaps), and gap_r (row gaps).
                if LOT_Parent.child_flex.gap_c.behavior = pixel then
                    gap_c := LOT_Parent.child_flex.gap_c.pixel;
                elsif LOT_Parent.child_flex.gap_c.behavior = percent then
                    gap_c :=
                       Natural
                          (Float (LOT_Parent.child_flex.gap_c.percent) *
                           Float (LOT_pw));
                end if;

                if LOT_Parent.child_flex.gap_r.behavior = pixel then
                    gap_r := LOT_Parent.child_flex.gap_r.pixel;
                elsif LOT_Parent.child_flex.gap_r.behavior = percent then
                    gap_r :=
                       Natural
                          (Float (LOT_Parent.child_flex.gap_r.percent) *
                           Float (LOT_ph));
                end if;

                for i in Layout_Object_Tree.Iterate_Children (LOT, c) loop
                    if child_row then
                        expand_w := LOT (i).self_flex.expand_w;
                        case expand_w.behavior is
                            when portion =>
                                total_portion :=
                                   total_portion + expand_w.portion;
                            when pixel =>
                                if expand_w.pixel <= width_pixel_left then
                                    width_pixel_left :=
                                       width_pixel_left - expand_w.pixel;
                                else
                                    width_pixel_left := 0;
                                end if;
                            when percent =>
                                if (Natural
                                       (Float (LOT_Parent.w) *
                                        Float (expand_w.percent))) <=
                                   width_pixel_left
                                then
                                    width_pixel_left :=
                                       width_pixel_left -
                                       Natural
                                          (Float (LOT_Parent.w) *
                                           Float (expand_w.percent));
                                else
                                    width_pixel_left := 0;
                                end if;
                            when content =>
                                null;
                            when max =>
                                nmbr_max := nmbr_max + 1;
                        end case;
                    elsif child_column then
                        expand_h := LOT (i).self_flex.expand_h;
                        case expand_h.behavior is
                            when portion =>
                                total_portion :=
                                   total_portion + expand_h.portion;
                            when pixel =>
                                if expand_h.pixel <= height_pixel_left then
                                    height_pixel_left :=
                                       height_pixel_left - expand_h.pixel;
                                else
                                    height_pixel_left := 0;
                                end if;
                            when percent =>
                                if (Natural
                                       (Float (LOT_Parent.h) *
                                        Float (expand_h.percent))) <=
                                   height_pixel_left
                                then
                                    height_pixel_left :=
                                       height_pixel_left -
                                       Natural
                                          (Float (LOT_Parent.h) *
                                           Float (expand_h.percent));
                                else
                                    height_pixel_left := 0;
                                end if;
                            when content =>
                                null;
                            when max =>
                                nmbr_max := nmbr_max + 1;
                        end case;
                    elsif child_depth then
                        null;
                    end if;
                end loop;
            end calculate_portions;

            procedure calculate_children_coordinates is
                left_boundary, right_boundary, top_boundary,
                bottom_boundary : Natural;
            begin
                for i in Layout_Object_Tree.Iterate_Children (LOT, c) loop
                    if LOT_Parent.child_flex.dir = right_left then
                        LOT (i).x :=
                           LOT_pw - LOT_ox - LOT (i).w + 2 * LOT_Parent.x;
                        LOT (i).y := LOT_oy;
                    elsif LOT_Parent.child_flex.dir = bottom_top then
                        LOT (i).y :=
                           LOT_ph - LOT_oy - LOT (i).h + 2 * LOT_Parent.y;
                        LOT (i).x := LOT_ox;
                    else
                        LOT (i).x := LOT_ox;
                        LOT (i).y := LOT_oy;
                    end if;
                    expand_w := LOT (i).self_flex.expand_w;
                    expand_h := LOT (i).self_flex.expand_h;

                    -- Dom approach, take the time to directly allocate boundaries.
                    left_boundary   := LOT_Parent.x;
                    right_boundary  := LOT_Parent.x + LOT_Parent.w;
                    top_boundary    := LOT_Parent.y;
                    bottom_boundary := LOT_Parent.y + LOT_Parent.h;

                    if child_row then

                        if LOT_ox < right_boundary then

                            case expand_w.behavior
                            is -- update w in row context
                                when portion =>
                                    LOT (i).all.Set_Width
                                       ((LOT_Parent.w / total_portion) *
                                        expand_w.portion);
                                when pixel =>
                                    LOT (i).all.Set_Width (expand_w.pixel);
                                when percent =>
                                    LOT (i).all.Set_Width
                                       (natural
                                           (float (LOT_Parent.w) *
                                            float (expand_w.percent)));
                                when content =>
                                    null;
                                when max =>
                                    LOT (i).all.Set_Width
                                       (width_pixel_left / nmbr_max);
                            end case;
                            case expand_h.behavior
                            is  -- update h in row context
                                when portion =>
                                    null;
                                when pixel =>
                                    LOT (i).all.Set_Height (expand_h.pixel);
                                when percent =>
                                    LOT (i).all.Set_Height
                                       (natural
                                           (float (LOT_Parent.h) *
                                            float (expand_h.percent)));
                                when content =>
                                    null;
                                when max =>
                                    LOT (i).all.Set_Height (LOT_Parent.h);
                            end case;

                            if (LOT_ox + LOT (i).w + gap_c) > right_boundary
                            then
                            --Overflow is occuring. First check if overflow occurs with or without gap.
                                if (Lot_ox + LOT (i).w) > right_boundary
                                then --Checking if overflow occurs without gap.
                                --If it does, then we resize widget to fit remaining space.
                                    LOT (i).w := right_boundary - LOT_ox;
                                end if;

                                LOT_ox :=
                                   right_boundary; -- Resolve overflow by setting offset to boundary to signal remaining widgets to zero out.
                            else
                                LOT_ox :=
                                   LOT_ox + LOT (i).w +
                                   gap_c; --If overflow has yet to occur, continue shifting offset.
                            end if;

                        else
                            LOT (i).x :=
                               0; --If overflow occured in a previous widget, zero out this widget.
                            LOT (i).y := 0;
                            LOT (i).w := 0;
                            LOT (i).h := 0;
                        end if;

                        --  if LOT_ox >= 480 then
                        --      null;
                        --  elsif LOT_ox + LOT(i).w + gap_c > 480 then
                        --       --Overflow occuring, need to provide remaining width to current widget, set LOT_ox to 480.
                        --       LOT(i).w := (LOT_pw + LOT_Parent.x) - LOT_ox;
                        --       LOT_ox := 480;
                        --  elsif LOT_ox + LOT(i).w + gap_c <= 480 then
                        --      LOT_ox := LOT_ox + LOT (i).w + gap_c;
                        --  else
                        --      null;
                        --  end if;

                    elsif child_column then

                        if LOT_oy < bottom_boundary then

                            case expand_h.behavior
                            is -- update h in column context
                                when portion =>
                                    LOT (i).all.Set_Height
                                       ((LOT_Parent.h / total_portion) *
                                        expand_h.portion);
                                when pixel =>
                                    LOT (i).all.Set_Height (expand_h.pixel);
                                when percent =>
                                    LOT (i).all.Set_Height
                                       (natural
                                           (float (LOT_Parent.h) *
                                            float (expand_h.percent)));
                                when content =>
                                    null;
                                when max =>
                                    LOT (i).all.Set_Height
                                       (height_pixel_left / nmbr_max);
                            end case;
                            case expand_w.behavior
                            is -- update w in column context
                                when portion =>
                                    null;
                                when pixel =>
                                    LOT (i).all.Set_Width (expand_w.pixel);
                                when percent =>
                                    LOT (i).all.Set_Width
                                       (natural
                                           (float (LOT_Parent.w) *
                                            float (expand_w.percent)));
                                when content =>
                                    null;
                                when max =>
                                    LOT (i).all.Set_Width (LOT_Parent.w);
                            end case;

                            if (LOT_oy + LOT (i).h + gap_r) > bottom_boundary
                            then
                            --Overflow occuring, first check if it occurs with or without gap.
                                if (Lot_oy + LOT (i).h) > bottom_boundary then
                                --If it does, resize widget to fill remaining space.
                                    LOT (i).h := bottom_boundary - LOT_oy;
                                end if;

                                LOT_oy :=
                                   bottom_boundary; --set offset to boundary, signaling remaining widgets to zero out.

                            else
                                LOT_oy :=
                                   LOT_oy + LOT (i).h +
                                   gap_r; --O If no overflow, continue shifitng offset.
                            end if;

                        else
                            LOT (i).x := 0;
                            LOT (i).y := 0;
                            LOT (i).w := 0;
                            LOT (i).h := 0;
                        end if;

                        --  if LOT_oy > 272 then
                        --      null;
                        --  else
                        --      if LOT_oy + LOT(i).h + gap_r <= 272 then
                        --          LOT_oy := LOT_oy + LOT (i).h + gap_r;
                        --      elsif LOT_oy + LOT(i).h + gap_r > 272 then
                        --          --Overflow occured, provide remainder of height to current child and zero out any remaining children.
                        --          LOT(i).h := (LOT_ph + LOT_Parent.y) - LOT_oy;
                        --          LOT_oy := 273;
                        --      end if;
                        --  end if;

                    elsif child_depth then
                        null;
                    end if;
                end loop;
            end calculate_children_coordinates;

            procedure calculate_buoy is
                r_width         : Natural := 0;
                r_height        : Natural := 0;
                c_total_width   : Natural := 0;
                c_total_height  : Natural := 0;
                space_between_x : Natural := 0;
                space_between_y : Natural := 0;
                space_around_x  : Natural := 0;
                space_around_y  : Natural := 0;
                space_evenly_x  : Natural := 0;
                space_evenly_y  : Natural := 0;
            begin
                buoy_wh := LOT_Parent.child_flex.buoy;
                case buoy_wh is
                    when space_between =>
                        for i in Layout_Object_Tree.Iterate_Children (LOT, c)
                        loop
                            c_total_width  := LOT (i).w + c_total_width;
                            c_total_height := LOT (i).h + c_total_height;
                        end loop;

                        space_between_x := (LOT_pw - c_total_width) / (cc - 1);
                        space_between_y :=
                           (LOT_ph - c_total_height) / (cc - 1);
                        for i in Layout_Object_Tree.Iterate_Children (LOT, c)
                        loop
                            if LOT_Parent.child_flex.dir = right_left then
                                if r_width = 0 then
                                    r_width := LOT (i).x;
                                else
                                    LOT (i).x :=
                                       r_width - space_between_x - LOT (i).w;
                                    r_width   := LOT (i).x;
                                end if;
                            elsif LOT_Parent.child_flex.dir = left_right then
                                if r_width = 0 then
                                    r_width := LOT (i).w + LOT (i).x;
                                else
                                    LOT (i).x := space_between_x + r_width;
                                    r_width   := LOT (i).w + LOT (i).x;
                                end if;
                            else
                                null;
                            end if;
                            if LOT_Parent.child_flex.dir = bottom_top then
                                if r_height = 0 then
                                    r_height := LOT (i).y;
                                else
                                    LOT (i).y :=
                                       r_height - space_between_y - LOT (i).h;
                                    r_height  := LOT (i).y;
                                end if;
                            elsif LOT_Parent.child_flex.dir = top_bottom then
                                if r_height = 0 then
                                    r_height := LOT (i).h + LOT (i).y;
                                else
                                    LOT (i).y := space_between_y + r_height;
                                    r_height  := LOT (i).h + LOT (i).y;
                                end if;
                            else
                                null;
                            end if;
                        end loop;
                    when space_around =>
                        for i in Layout_Object_Tree.Iterate_Children (LOT, c)
                        loop
                            c_total_width  := LOT (i).w + c_total_width;
                            c_total_height := LOT (i).h + c_total_height;
                        end loop;
                        space_around_x := (LOT_pw - c_total_width) / (2 * cc);
                        space_around_y := (LOT_ph - c_total_height) / (2 * cc);
                        for i in Layout_Object_Tree.Iterate_Children (LOT, c)
                        loop
                            if LOT_Parent.child_flex.dir = right_left then
                                if r_width = 0 then
                                    LOT (i).x := LOT (i).x - space_around_x;
                                    r_width   := LOT (i).x;
                                else
                                    LOT (i).x :=
                                       r_width - 2 * space_around_x -
                                       LOT (i).w;
                                    r_width   := LOT (i).x;
                                end if;
                            elsif LOT_Parent.child_flex.dir = left_right then
                                if r_width = 0 then
                                    LOT (i).x := LOT (i).x + space_around_x;
                                    r_width   := LOT (i).w + LOT (i).x;
                                else
                                    LOT (i).x := 2 * space_around_x + r_width;
                                    r_width   := LOT (i).w + LOT (i).x;
                                end if;
                            else
                                null;
                            end if;
                            if LOT_Parent.child_flex.dir = bottom_top then
                                if r_height = 0 then
                                    LOT (i).y := LOT (i).y - space_around_y;
                                    r_height  := LOT (i).y;
                                else
                                    LOT (i).y :=
                                       r_height - 2 * space_around_y -
                                       LOT (i).h;
                                    r_height  := LOT (i).y;
                                end if;
                            elsif LOT_Parent.child_flex.dir = top_bottom then
                                if r_height = 0 then
                                    LOT (i).y := LOT (i).y + space_around_y;
                                    r_height  := LOT (i).h + LOT (i).y;
                                else
                                    LOT (i).y := 2 * space_around_y + r_height;
                                    r_height  := LOT (i).h + LOT (i).y;
                                end if;
                            else
                                null;
                            end if;
                        end loop;
                    when space_evenly =>
                        for i in Layout_Object_Tree.Iterate_Children (LOT, c)
                        loop
                            c_total_width  := LOT (i).w + c_total_width;
                            c_total_height := LOT (i).h + c_total_height;
                        end loop;
                        space_evenly_x := (LOT_pw - c_total_width) / (cc + 1);
                        space_evenly_y := (LOT_ph - c_total_height) / (cc + 1);
                        for i in Layout_Object_Tree.Iterate_Children (LOT, c)
                        loop
                            if LOT_Parent.child_flex.dir = right_left then
                                if r_width = 0 then
                                    LOT (i).x := LOT (i).x - space_evenly_x;
                                    r_width   := LOT (i).x;
                                else
                                    LOT (i).x :=
                                       r_width - space_evenly_x - LOT (i).w;
                                    r_width   := LOT (i).x;
                                end if;
                            elsif LOT_Parent.child_flex.dir = left_right then
                                if r_width = 0 then
                                    LOT (i).x := LOT (i).x + space_evenly_x;
                                    r_width   := LOT (i).w + LOT (i).x;
                                else
                                    LOT (i).x := space_evenly_x + r_width;
                                    r_width   := LOT (i).w + LOT (i).x;
                                end if;
                            else
                                null;
                            end if;
                            if LOT_Parent.child_flex.dir = bottom_top then
                                if r_height = 0 then
                                    LOT (i).y := LOT (i).y - space_evenly_y;
                                    r_height  := LOT (i).y;
                                else
                                    LOT (i).y :=
                                       r_height - space_evenly_y - LOT (i).h;
                                    r_height  := LOT (i).y;
                                end if;
                            elsif LOT_Parent.child_flex.dir = top_bottom then
                                if r_height = 0 then
                                    LOT (i).y := LOT (i).y + space_evenly_y;
                                    r_height  := LOT (i).h + LOT (i).y;
                                else
                                    LOT (i).y := space_evenly_y + r_height;
                                    r_height  := LOT (i).h + LOT (i).y;
                                end if;
                            else
                                null;
                            end if;
                        end loop;
                    when space_nothing =>
                        null;
                    when others =>
                        null;
                end case;
            end calculate_buoy;

            procedure calculate_align is
                next_x : Natural :=
                   LOT_Parent
                      .x; -- variable to calculate the next x-coord of siblings when calculating left alignment
                next_y : Natural :=
                   LOT_Parent
                      .y; -- variable to calculate the next y-coord of siblings when calculating left alignment
            begin
                align_wh := LOT_Parent.child_flex.align;
                case align_wh is
                    when stretch =>
                        for i in Layout_Object_Tree.Iterate_Children (LOT, c)
                        loop
                            case LOT_Parent.child_flex.dir is
                                when left_right | right_left =>
                                    LOT (i).h := LOT_ph;

                                when bottom_top | top_bottom =>
                                    LOT (i).w := LOT_pw;

                                when others =>
                                    null;
                            end case;
                        end loop;

                    when center =>
                        for i in Layout_Object_Tree.Iterate_Children (LOT, c)
                        loop
                            case LOT_Parent.child_flex.dir is
                                when left_right | right_left =>
                                    LOT (i).y := (LOT_ph - LOT (i).h) / 2;

                                when bottom_top | top_bottom =>
                                    LOT (i).x :=
                                       (LOT_pw / 2) - (LOT (i).w / 2);

                                when others =>
                                    null;
                            end case;
                        end loop;

                    when bottom =>
                        next_y := LOT_ph;
                        for i in Layout_Object_Tree.Iterate_Children (LOT, c)
                        loop
                            case LOT_Parent.child_flex.dir is
                                when left_right | right_left =>
                                    LOT (i).y := LOT_ph - LOT (i).h - LOT_oy;

                                when bottom_top | top_bottom =>
                                    next_y    := next_y - LOT (i).h;
                                    LOT (i).y := next_y;

                                when others =>
                                    null;
                            end case;
                        end loop;

                    when left =>
                        for i in Layout_Object_Tree.Iterate_Children (LOT, c)
                        loop
                            case LOT_Parent.child_flex.dir is
                                when left_right | right_left =>
                                    LOT (i).x := next_x;
                                    next_x    := next_x + LOT (i).w;

                                when top_bottom | bottom_top =>
                                    LOT (i).x := LOT_Parent.x;
                                    LOT (i).y := next_y;
                                    next_y    := next_y + LOT (i).h;

                                when others =>
                                    null;
                            end case;
                        end loop;

                    when right =>
                        next_x := LOT_Parent.x + LOT_Parent.w;
                        for i in Layout_Object_Tree.Iterate_Children (LOT, c)
                        loop
                            case LOT_Parent.child_flex.dir is
                                when left_right | right_left =>
                                    next_x := next_x - LOT (i).w;

                                    if next_x >= LOT_Parent.x then
                                        LOT (i).x := next_x;

                                    end if;

                                when top_bottom | bottom_top =>
                                    LOT (i).x :=
                                       LOT_Parent.x + LOT_Parent.w - LOT (i).w;
                                    LOT (i).y := next_y;
                                    next_y    := next_y + LOT (i).h;

                                when others =>
                                    null;
                            end case;
                        end loop;
                    when others =>
                        null; -- Currently not handling other alignment types
                end case;
            end calculate_align;

        begin
            if cc > 0 then
                begin
                    calculate_portions; -- Procedure call calculates data necessary to calculate (x,y) coordinates of widgets to be drawn.
                    calculate_children_coordinates; -- Procedure call traverses children of current widget to calculate their (x,y) coordinates.
                    if cc > 1 then
                        calculate_buoy; -- Procedure call recalculates (x,y) coordinates of child widgets to apply buoyancy format
                        --calculate_gap; -- Procedure call recalculates (x,y) coordinates of child widgets to apply gap size
                        calculate_align;
                    end if;
                end;
            end if;
        end compute_node;

        --      Start_Time   : Time;
        --      Elapsed_Time : Time_Span;

    begin
        loop
            --      Start_Time                                        := Clock;
            LOT (Layout_Object_Tree.First_Child (LOT.Root)).w := window_width;
            LOT (Layout_Object_Tree.First_Child (LOT.Root)).h := window_height;
            Layout_Object_Tree.Iterate (LOT, compute_node'Access);
            --Layout_Object_Tree.Iterate (LOT, render_node'Access);

            --  for C in LOT.Iterate loop
            --  declare
            --   widg : Widget.Any_Acc := Layout_Object_Tree.Element(c);
            --  begin
            --      widg.x := 0;
            --      widg.y := 0;
            --      widg.w := 100;
            --      widg.h := 100;
            --  end;
            --  end loop;

            render_node;

            -- Move Buffered layer to visible layer.
            --STM32.Board.Display.Update_Layer(1);
            --      Layout_Object_Tree.Iterate (LOT, debug_dui'Access);
            --      --Layout_Object_Tree.Iterate (LOT, test'access);
            --      Elapsed_Time := Clock - Start_Time;
            --      -- Put_Line ("Elapsed time (whole dui): "
            --      --    & Duration'Image (To_Duration (Elapsed_Time))
            --      --    & " seconds");

        end loop;
    end render;

    --  procedure handle_click_event (x_Input : Natural; y_Input : Natural) is

    --      procedure click_event (c : Layout_Object_Tree.Cursor) is
    --      begin
    --          if Layout_Object_Tree.Element (c).Is_In_Bound (x_Input, y_Input)
    --          then
    --              Layout_Object_Tree.Element (c).Click;
    --          end if;
    --      end click_event;

    --  begin
    --      Layout_Object_Tree.Iterate (LOT, click_event'Access);
    --  end handle_click_event;

    --  procedure handle_release_event is
    --      procedure release_event (c : Layout_Object_Tree.Cursor) is
    --      begin
    --          if Layout_Object_Tree.Element (c).Is_Clickable then
    --              Widget.Button.Any_Acc (Layout_Object_Tree.Element (c))
    --                 .release_click;
    --          end if;
    --      end release_event;
    --  begin
    --      Layout_Object_Tree.Iterate (LOT, release_event'Access);
    --  end handle_release_event;

begin

    -- initialize STM32 Board Display
    STM32.Board.Display.Initialize;
    STM32.Board.Display.Initialize_Layer (1, HAL.Bitmap.ARGB_1555);
    STM32.Board.Touch_Panel.Initialize;

    main_widget :=
       new Widget.Instance'
          (Controlled with id => +"main",
           child_flex         => (dir => left_right, others => <>),
           bgd                => HAL.Bitmap.Grey, others => <>);
    LOT.Append_Child (Parent => LOT_Root, New_Item => main_widget);
    LOT_Root := Layout_Object_Tree.First_Child (LOT_Root);
    --font.font_1_img := g.Load_QOI ("data/font_1.qoi");
end dui;
