with Ada.Finalization; use Ada.Finalization;
with Ada.Real_Time; use Ada.Real_Time;
with Ada.Text_IO; use Ada.Text_IO;
with STM32.Board; use STM32.Board;
with HAL.Bitmap; use HAL.Bitmap;
with HAL.Touch_Panel; use HAL.Touch_Panel;
with BMP_Fonts;
with Bitmap_Color_Conversion; use Bitmap_Color_Conversion;
with HAL.Framebuffer;
with Bitmapped_Drawing; use Bitmapped_Drawing;
with Ada.Numerics; use Ada.Numerics;

with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Containers.Multiway_Trees;

with Widget;
with Widget.Button;
with Widget_Observer;

package body dui is

    procedure add_to_LOT (Widget : Any_Acc; Parent : Any_Acc) is
        parent_c : Layout_Object_Tree.Cursor :=
           Layout_Object_Tree.Find (Container => LOT, Item => Parent);
        cc : Natural := Natural (Layout_Object_Tree.Child_Count (parent_c));
    begin
        if cc = 0 then
            dui.LOT.Append_Child (parent_c, Widget);
        else
            declare
                current_sibling : Layout_Object_Tree.Cursor := Layout_Object_Tree.First_Child (parent_c);
                last_sibling : Layout_Object_Tree.Cursor := Layout_Object_Tree.Last_Child(parent_c);
                Inserted : Boolean := False;
                Incrementor : Natural := 1;
            begin
                while Incrementor < cc and Inserted = False loop
                    if Widget.priority > Layout_Object_Tree.Element (current_sibling).priority
                    then
                        dui.LOT.Insert_Child(Parent => parent_c, Before => current_sibling, New_Item => Widget);
                        Inserted := True;
                    else
                        current_sibling := Layout_Object_Tree.Next_Sibling(current_sibling);
                        Incrementor := Incrementor + 1;
                    end if;
                end loop;
                if Inserted = False then
                    if Widget.priority > Layout_Object_Tree.Element (last_sibling).priority 
                    then
                        dui.LOT.Insert_Child(Parent => parent_c, Before => last_sibling, New_Item => Widget);
                    else
                        dui.LOT.Append_Child (parent_c, Widget);
                    end if;
                end if;
            end;
        end if;
    end add_to_LOT;

    -- need a pass from leaf to root to compute intrinsic, inner content width and height

    procedure render (window_width : Natural; window_height : Natural) is

        procedure render_node is
        begin
            -- For "clearing" the screen for resizing
            STM32.Board.Display.Hidden_Buffer (1).Set_Source
               (HAL.Bitmap.Black);
            STM32.Board.Display.Hidden_Buffer (1).Fill_Rect
               (Area =>
                   (Position => (0, 0), Width => window_width,
                    Height => window_height));
            for C in LOT.Iterate loop
                declare
                    w : Widget.Any_Acc := Layout_Object_Tree.Element (C);
                begin
                    Layout_Object_Tree.Element (C).Draw
                       (img => STM32.Board.Display.Hidden_Buffer (1).all);
                end;
            end loop;
            STM32.Board.Display.Update_Layer (1);
        end render_node;

        procedure compute_node (c : Layout_Object_Tree.Cursor) is
            cc : Natural := Natural (Layout_Object_Tree.Child_Count (c));
            LOT_Parent : Widget.Class :=
               Layout_Object_Tree.Element (c).all; --parent
            LOT_pw : Natural := LOT_Parent.w; --parent width
            LOT_ph : Natural := LOT_Parent.h; --parent height
            LOT_ox : Natural := LOT_Parent.x; --x offset for calculations
            LOT_oy : Natural := LOT_Parent.y; --y offset for calculations
            child_row : Boolean :=
               (LOT_Parent.child_flex.dir = left_right or
                LOT_Parent.child_flex.dir = right_left);
            child_column : Boolean :=
               (LOT_Parent.child_flex.dir = top_bottom or
                LOT_Parent.child_flex.dir = bottom_top);
            child_depth : Boolean :=
               (LOT_Parent.child_flex.dir = front_back or
                LOT_Parent.child_flex.dir = back_front);
            buoy_wh : buoy_t;
            align_wh : align_t;
            gap_r, gap_c : Natural;
            expand_w, expand_h : expand_t;
            expand_wc, expand_hc : expand_t; --child behavior
            width_pixel_left : Natural := LOT_Parent.w;
            height_pixel_left : Natural := LOT_Parent.h;
            total_portion : Natural := 0;
            nmbr_max : Natural := 0;
            content_width : Natural := 0;
            content_height : Natural := 0;

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
                                for j in Layout_Object_Tree.Iterate_Subtree (i)
                                loop
                                    if child_row then
                                        expand_wc :=
                                           LOT (j).self_flex.expand_w;
                                        case expand_wc.behavior is
                                            when portion =>
                                                content_width :=
                                                   content_width +
                                                   expand_wc.portion;
                                            when pixel =>
                                                content_width :=
                                                   content_width +
                                                   expand_wc.pixel;
                                            when percent =>
                                                content_width :=
                                                   content_width +
                                                   Natural
                                                      (Float (LOT_Parent.w) *
                                                       Float
                                                          (expand_wc.percent));
                                            when content =>
                                                null;
                                            when max =>
                                                null;
                                        end case;
                                    end if;
                                end loop;
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
                                for j in Layout_Object_Tree.Iterate_Subtree (i)
                                loop
                                    if child_column then
                                        expand_hc :=
                                           LOT (j).self_flex.expand_h;
                                        case expand_hc.behavior is
                                            when portion =>
                                                content_height :=
                                                   content_height +
                                                   expand_hc.portion;
                                            when pixel =>
                                                content_height :=
                                                   content_height +
                                                   expand_hc.pixel;
                                            when percent =>
                                                content_height :=
                                                   content_height +
                                                   Natural
                                                      (Float (LOT_Parent.h) *
                                                       Float
                                                          (expand_hc.percent));
                                            when content =>
                                                null;
                                            when max =>
                                                null;
                                        end case;
                                    end if;
                                end loop;
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
                    left_boundary := LOT_Parent.x;
                    right_boundary := LOT_Parent.x + LOT_Parent.w;
                    top_boundary := LOT_Parent.y;
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
                                    LOT (i).all.Set_Width (content_width);
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
                                    LOT (i).all.Set_Height (content_height);
                                when max =>
                                    LOT (i).all.Set_Height (LOT_Parent.h);
                            end case;

                            if (LOT_ox + LOT (i).w + gap_c) > right_boundary
                            then
                                --Overflow is occuring. First check if overflow occurs with or without gap.
                                if (LOT_ox + LOT (i).w) > right_boundary
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
                                    LOT (i).all.Set_Height (content_height);
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
                                    LOT (i).all.Set_Width (content_width);
                                when max =>
                                    LOT (i).all.Set_Width (LOT_Parent.w);
                            end case;

                            if (LOT_oy + LOT (i).h + gap_r) > bottom_boundary
                            then
                                --Overflow occuring, first check if it occurs with or without gap.
                                if (LOT_oy + LOT (i).h) > bottom_boundary then
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

                    elsif child_depth then
                        null;
                    end if;
                end loop;
            end calculate_children_coordinates;

            procedure calculate_buoy is
                r_width : Natural := 0;
                r_height : Natural := 0;
                c_total_width : Natural := 0;
                c_total_height : Natural := 0;
                space_between_x : Natural := 0;
                space_between_y : Natural := 0;
                space_around_x : Natural := 0;
                space_around_y : Natural := 0;
                space_evenly_x : Natural := 0;
                space_evenly_y : Natural := 0;
            begin
                buoy_wh := LOT_Parent.child_flex.buoy;

                case buoy_wh is
                    when space_between =>
                        for i in Layout_Object_Tree.Iterate_Children (LOT, c)
                        loop
                            c_total_width := LOT (i).w + c_total_width;
                            c_total_height := LOT (i).h + c_total_height;
                        end loop;

                        if ((LOT_pw - c_total_width) / (cc - 1)) >= 0 then
                            space_between_x :=
                               (LOT_pw - c_total_width) / (cc - 1);
                        else
                            space_between_x := 0;
                        end if;
                        if ((LOT_ph - c_total_height) / (cc - 1)) >= 0 then
                            space_between_y :=
                               (LOT_ph - c_total_height) / (cc - 1);
                        else
                            space_between_y := 0;
                        end if;

                        for i in Layout_Object_Tree.Iterate_Children (LOT, c)
                        loop
                            if LOT_Parent.child_flex.dir = right_left then
                                if r_width = 0 then
                                    r_width := LOT (i).x;
                                else
                                    LOT (i).x :=
                                       r_width - space_between_x - LOT (i).w;
                                    r_width := LOT (i).x;
                                end if;
                            elsif LOT_Parent.child_flex.dir = left_right then
                                if r_width = 0 then
                                    r_width := LOT (i).w + LOT (i).x;
                                else
                                    LOT (i).x := space_between_x + r_width;
                                    r_width := LOT (i).w + LOT (i).x;
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
                                    r_height := LOT (i).y;
                                end if;
                            elsif LOT_Parent.child_flex.dir = top_bottom then
                                if r_height = 0 then
                                    r_height := LOT (i).h + LOT (i).y;
                                else
                                    LOT (i).y := space_between_y + r_height;
                                    r_height := LOT (i).h + LOT (i).y;
                                end if;
                            else
                                null;
                            end if;
                        end loop;
                    when space_around =>
                        for i in Layout_Object_Tree.Iterate_Children (LOT, c)
                        loop
                            c_total_width := LOT (i).w + c_total_width;
                            c_total_height := LOT (i).h + c_total_height;
                        end loop;
                        if ((LOT_pw - c_total_width) / (2 * cc)) >= 0 then
                            space_around_x :=
                               (LOT_pw - c_total_width) / (2 * cc);
                        else
                            space_around_x := 0;
                        end if;
                        if ((LOT_ph - c_total_height) / (2 * cc)) >= 0 then
                            space_around_y :=
                               (LOT_ph - c_total_height) / (2 * cc);
                        else
                            space_around_y := 0;
                        end if;
                        for i in Layout_Object_Tree.Iterate_Children (LOT, c)
                        loop
                            if LOT_Parent.child_flex.dir = right_left then
                                if r_width = 0 then
                                    LOT (i).x := LOT (i).x - space_around_x;
                                    r_width := LOT (i).x;
                                else
                                    LOT (i).x :=
                                       r_width - 2 * space_around_x -
                                       LOT (i).w;
                                    r_width := LOT (i).x;
                                end if;
                            elsif LOT_Parent.child_flex.dir = left_right then
                                if r_width = 0 then
                                    LOT (i).x := LOT (i).x + space_around_x;
                                    r_width := LOT (i).w + LOT (i).x;
                                else
                                    LOT (i).x := 2 * space_around_x + r_width;
                                    r_width := LOT (i).w + LOT (i).x;
                                end if;
                            else
                                null;
                            end if;
                            if LOT_Parent.child_flex.dir = bottom_top then
                                if r_height = 0 then
                                    LOT (i).y := LOT (i).y - space_around_y;
                                    r_height := LOT (i).y;
                                else
                                    LOT (i).y :=
                                       r_height - 2 * space_around_y -
                                       LOT (i).h;
                                    r_height := LOT (i).y;
                                end if;
                            elsif LOT_Parent.child_flex.dir = top_bottom then
                                if r_height = 0 then
                                    LOT (i).y := LOT (i).y + space_around_y;
                                    r_height := LOT (i).h + LOT (i).y;
                                else
                                    LOT (i).y := 2 * space_around_y + r_height;
                                    r_height := LOT (i).h + LOT (i).y;
                                end if;
                            else
                                null;
                            end if;
                        end loop;
                    when space_evenly =>
                        for i in Layout_Object_Tree.Iterate_Children (LOT, c)
                        loop
                            c_total_width := LOT (i).w + c_total_width;
                            c_total_height := LOT (i).h + c_total_height;
                        end loop;
                        if ((LOT_pw - c_total_width) / (cc + 1)) >= 0 then
                            space_evenly_x :=
                               (LOT_pw - c_total_width) / (cc + 1);
                        else
                            space_evenly_x := 0;
                        end if;
                        if ((LOT_ph - c_total_height) / (cc + 1)) >= 0 then
                            space_evenly_y :=
                               (LOT_ph - c_total_height) / (cc + 1);
                        else
                            space_evenly_y := 0;
                        end if;
                        for i in Layout_Object_Tree.Iterate_Children (LOT, c)
                        loop
                            if LOT_Parent.child_flex.dir = right_left then
                                if r_width = 0 then
                                    LOT (i).x := LOT (i).x - space_evenly_x;
                                    r_width := LOT (i).x;
                                else
                                    LOT (i).x :=
                                       r_width - space_evenly_x - LOT (i).w;
                                    r_width := LOT (i).x;
                                end if;
                            elsif LOT_Parent.child_flex.dir = left_right then
                                if r_width = 0 then
                                    LOT (i).x := LOT (i).x + space_evenly_x;
                                    r_width := LOT (i).w + LOT (i).x;
                                else
                                    LOT (i).x := space_evenly_x + r_width;
                                    r_width := LOT (i).w + LOT (i).x;
                                end if;
                            else
                                null;
                            end if;
                            if LOT_Parent.child_flex.dir = bottom_top then
                                if r_height = 0 then
                                    LOT (i).y := LOT (i).y - space_evenly_y;
                                    r_height := LOT (i).y;
                                else
                                    LOT (i).y :=
                                       r_height - space_evenly_y - LOT (i).h;
                                    r_height := LOT (i).y;
                                end if;
                            elsif LOT_Parent.child_flex.dir = top_bottom then
                                if r_height = 0 then
                                    LOT (i).y := LOT (i).y + space_evenly_y;
                                    r_height := LOT (i).h + LOT (i).y;
                                else
                                    LOT (i).y := space_evenly_y + r_height;
                                    r_height := LOT (i).h + LOT (i).y;
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
                for i in Layout_Object_Tree.Iterate_Children (LOT, c) loop
                    if LOT (i).self_flex.align = stretch or
                       LOT (i).self_flex.align = center or
                       LOT (i).self_flex.align = bottom or
                       LOT (i).self_flex.align = left or
                       LOT (i).self_flex.align = right
                    then
                        case LOT (i).self_flex.align is
                            when stretch =>
                                case LOT_Parent.child_flex.dir is
                                    when left_right | right_left =>
                                        LOT (i).h := LOT_ph;

                                    when bottom_top | top_bottom =>
                                        LOT (i).w := LOT_pw;

                                    when others =>
                                        null;
                                end case;
                            when center =>
                                case LOT_Parent.child_flex.dir is
                                    when left_right | right_left =>
                                        LOT (i).y := (LOT_ph - LOT (i).h) / 2;

                                    when bottom_top | top_bottom =>
                                        LOT (i).x :=
                                           (LOT_pw / 2) - (LOT (i).w / 2);

                                    when others =>
                                        null;
                                end case;
                            when bottom =>
                                case LOT_Parent.child_flex.dir is
                                    when left_right | right_left =>
                                        LOT (i).y :=
                                           LOT_ph - LOT (i).h - LOT_oy;

                                    when bottom_top | top_bottom =>
                                        next_y := next_y - LOT (i).h;
                                        LOT (i).y := next_y;

                                    when others =>
                                        null;
                                end case;
                            when left =>
                                case LOT_Parent.child_flex.dir is
                                    when left_right | right_left =>
                                        LOT (i).x := next_x;
                                        next_x := next_x + LOT (i).w;

                                    when top_bottom | bottom_top =>
                                        LOT (i).x := LOT_Parent.x;
                                        LOT (i).y := next_y;
                                        next_y := next_y + LOT (i).h;

                                    when others =>
                                        null;
                                end case;
                            when right =>
                                case LOT_Parent.child_flex.dir is
                                    when left_right | right_left =>
                                        LOT (i).x := LOT_Parent.w - LOT (i).w;

                                    when top_bottom | bottom_top =>
                                        LOT (i).y := LOT_Parent.h - LOT (i).h;

                                    when others =>
                                        null;
                                end case;
                            when others =>
                                null; -- No action for unspecified alignments
                        end case;
                    end if;
                end loop;
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
                                    next_y := next_y - LOT (i).h;
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
                                    next_x := next_x + LOT (i).w;

                                when top_bottom | bottom_top =>
                                    LOT (i).x := LOT_Parent.x;
                                    LOT (i).y := next_y;
                                    next_y := next_y + LOT (i).h;

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
                                    next_y := next_y + LOT (i).h;

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
                        calculate_align;
                    end if;
                end;
            end if;
        end compute_node;

        procedure poll_events is
            State : constant TP_State :=
               STM32.Board.Touch_Panel.Get_All_Touch_Points;
            Curr_X : Natural := 0;
            Curr_Y : Natural := 0;
            Curr_W : Natural := 0;
        begin
            STM32.Board.Display.Hidden_Buffer (1).Set_Source
               (HAL.Bitmap.Green);

            if State'Length = 0 and event_state = idle then
                update_render := False;
            elsif State'Length = 1 and event_state = idle then
                null; -- button press here
                -- call observer button press event procedure
                Curr_X := State (State'First).X;
                Curr_Y := State (State'First).Y;
                Curr_W := State (State'First).Weight;
                for C in LOT.Iterate loop
                    --  if Layout_Object_Tree.Element (C).Is_In_Bound
                    --        (Curr_X, Curr_Y)
                    --  then
                    --      Layout_Object_Tree.Element (C).Click;
                    --  end if;
                    Widget_Observer.button_press_event(Curr_X, Curr_Y);
                end loop;
                event_state := press;
                update_render := True;
            elsif State'Length = 1 and event_state = press then
                null; -- idling in press (same press but waiting)
            elsif State'Length = 0 and event_state = press then
                -- press has been released; transition back to idle
                -- call observer button release procedure
                for C in LOT.Iterate loop
                    --  if Layout_Object_Tree.Element (C).Is_Clickable then
                    --      Widget.Button.Any_Acc (Layout_Object_Tree.Element (C))
                    --         .release_click;
                    --  end if;
                    Widget_Observer.button_release_event;
                end loop;
                event_state := idle;
            elsif State'Length = 2 and event_state /= resize then
                event_state := resize;
                -- set a starting point for each touch point
                declare
                    tx, ty : Integer := 0;
                    ft : Float := 0.0;
                    start_x1 : Natural := State (1).X;
                    start_y1 : Natural := State (1).Y;
                    start_x2 : Natural := State (2).X;
                    start_y2 : Natural := State (2).Y;
                begin
                    tx := Integer (start_x2) - Integer (start_x1);
                    ty := Integer (start_y2) - Integer (start_y1);
                    tx := tx**2;
                    ty := ty**2;
                    ft := Float (tx) + Float (ty);
                    start_dist := Sqrt (ft);
                    start_w :=
                       LOT (Layout_Object_Tree.First_Child (LOT.Root)).w;
                    start_h :=
                       LOT (Layout_Object_Tree.First_Child (LOT.Root)).h;
                end;
            elsif State'Length = 2 and event_state = resize then
                declare
                    tx, ty : Integer := 0;
                    dt : Float := 0.0;
                    ft : Float := 0.0;
                    x1 : Natural := State (1).X;
                    y1 : Natural := State (1).Y;
                    x2 : Natural := State (2).X;
                    y2 : Natural := State (2).Y;
                begin
                    tx := Integer (x2) - Integer (x1);
                    ty := Integer (y2) - Integer (y1);
                    tx := tx**2;
                    ty := ty**2;
                    ft := Float (tx) + Float (ty);
                    dt := Sqrt (ft);
                    if dt /= start_dist then
                        -- stretch and squish
                        LOT (Layout_Object_Tree.First_Child (LOT.Root)).w :=
                           Natural (Float (start_w) * (dt / start_dist));
                        LOT (Layout_Object_Tree.First_Child (LOT.Root)).h :=
                           Natural (Float (start_h) * (dt / start_dist));
                        if LOT (Layout_Object_Tree.First_Child (LOT.Root)).w >
                           window_width
                        then
                            LOT (Layout_Object_Tree.First_Child (LOT.Root))
                               .w :=
                               window_width;
                        end if;
                        if LOT (Layout_Object_Tree.First_Child (LOT.Root)).h >
                           window_height
                        then
                            LOT (Layout_Object_Tree.First_Child (LOT.Root))
                               .h :=
                               window_height;
                        end if;
                        if LOT (Layout_Object_Tree.First_Child (LOT.Root)).w <=
                           0
                        then
                            LOT (Layout_Object_Tree.First_Child (LOT.Root))
                               .w :=
                               1;
                        end if;
                        if LOT (Layout_Object_Tree.First_Child (LOT.Root)).h <=
                           0
                        then
                            LOT (Layout_Object_Tree.First_Child (LOT.Root))
                               .h :=
                               1;
                        end if;
                    end if;
                    update_render := True;
                end;
            elsif State'Length < 2 and event_state = resize then
                event_state := idle;
            else
                null;
            end if;

        end poll_events;

    begin
        LOT (Layout_Object_Tree.First_Child (LOT.Root)).w := window_width;
        LOT (Layout_Object_Tree.First_Child (LOT.Root)).h := window_height;
        for i in 1 .. 2 loop
            Layout_Object_Tree.Iterate (LOT, compute_node'Access);
            render_node;
        end loop;
        loop
            poll_events;
            if update_render then
                Layout_Object_Tree.Iterate (LOT, compute_node'Access);
                render_node;
            end if;

        end loop;
    end render;

begin

    -- initialize STM32 Board Display
    STM32.Board.Display.Initialize;
    STM32.Board.Display.Initialize_Layer (1, HAL.Bitmap.ARGB_1555);
    STM32.Board.Touch_Panel.Initialize;

    main_widget :=
       new Widget.Instance'
          (Controlled with id => +"main",
           child_flex => (dir => top_bottom, others => <>),
           bgd => HAL.Bitmap.Grey, others => <>);
    LOT.Append_Child (Parent => LOT_Root, New_Item => main_widget);
    LOT_Root := Layout_Object_Tree.First_Child (LOT_Root);
end dui;
