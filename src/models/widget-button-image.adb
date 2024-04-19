with Ada.Text_IO; use Ada.Text_IO;
with dui;
with Hal.Bitmap;  use Hal.Bitmap;
with STM32.Board;
with Widget_Observer;

package body Widget.Button.Image is

    function Create (id            : string;
                     Parent        : Widget.Any_acc;
                     target        : Widget.Any_Acc;
                     image_left    : Widget.Any_Acc;
                     image_right   : Widget.Any_Acc;
                     gallery_text : Widget.Any_Acc;
                     text          : string := "";
                     overflow_text : text_overflow := truncate;
                     self_flex     : flex_t  := default_flex;
                     child_flex    : flex_t  := default_flex;
                     min_height, min_width : Natural := 0;
                     max_height, max_width : Natural := Natural'Last;
                     priority      : Natural := 0;
                     bgd           : Bitmap_Color) return Widget.Any_Acc is
        this : Widget.Any_Acc;
    begin
        this := new Instance' (Ada.Finalization.Controlled with
                              id            => +id,
                              self_flex     => self_flex,
                              target        => target,
                              image_left    => image_left,
                              image_right   => image_right,
                              gallery_text  => gallery_text,
                              child_flex    => child_flex,
                              min_height    => min_height, 
                              min_width     => min_width, 
                              max_height    => max_height, 
                              max_width     => max_width,
                              priority      => priority,
                              bgd           => bgd,
                              others        => <>);
        
        if bgd = HAL.Bitmap.White then
            Any_Acc(this).colors(idle) := bgd;
            Any_Acc(this).colors(clicking) := HAL.Bitmap.Gray;
        else
            Any_Acc(this).colors(idle) := bgd;
        end if;
        
        dui.add_to_LOT (This, Parent);
        Widget_Observer.add_Widget(This);
        
        if text /= "" then
        Button.Any_Acc(this).button_text := 
            Widget.Text.Create
            (id        => id & ".text", parent => this, text => text, overflow => overflow_text,
            self_flex =>
                (expand_w => (behavior => max), expand_h => (behavior => max), others => <>));
        end if;
        return This;
    end;

    
    procedure release_click(This: in out Instance) is
    begin
        if This.state = clicking then
            This.state := idle;
            This.bgd := This.colors(idle);
            This.switch_image;
            if This.button_text /= null then
                This.button_text.bgd := This.colors(idle);
            end if;
        end if;
    end release_click;

    procedure switch_image (This : in out Instance) is
    Main_Instance : Widget.Image.Any_Acc := Widget.Image.Any_Acc(This.Target);
    Left_Instance : Widget.Image.Any_Acc := Widget.Image.Any_Acc(This.image_left);
    Right_Instance : Widget.Image.Any_Acc := Widget.Image.Any_Acc(This.image_right);
    Text_Instance : Widget.Text.Any_Acc := Widget.Text.Any_Acc(This.gallery_text);
    begin

        if To_String(Main_Instance.Image) = "ada" then 
            Main_Instance.Image := +"spark";
            Right_Instance.Image := +"ada";
            Left_Instance.Image := +"lady_ada";
            Text_Instance.text := +"Spark Logo";
        elsif To_String(Main_Instance.Image) = "spark" then
            Main_Instance.Image := +"lady_ada";
            Right_Instance.Image := +"spark";
            Left_Instance.Image := +"psu_shield";
            Text_Instance.text := +"Ada Lovelace";
        elsif To_String(Main_Instance.Image) = "lady_ada" then
            Main_Instance.Image := +"psu_shield";
            Left_Instance.Image := +"ada";
            Right_Instance.Image := +"lady_ada";
            Text_Instance.text := +"PSU Shield";
        else
            Main_Instance.Image := +"ada";
            Right_Instance.Image := +"psu_shield";
            Left_Instance.Image := +"spark";
            Text_Instance.text := +"Ada Logo";
        end if;

    end switch_image;

end Widget.Button.Image;