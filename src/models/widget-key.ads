with Widget; use Widget;
with widget.Text; use widget.Text;
with Widget.Button; use Widget.Button;
with BMP_Fonts; use BMP_Fonts;
package Widget.Key is

    subtype Parent is Widget.Button.Instance;
    type Instance is new Parent with record
        target : Widget.Text.Any_Acc;
    end record;


    function Create (id            : string;
                    parent        : Widget.Any_Acc;
                    target : Widget.Any_Acc;
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
    procedure Click (This: in out Instance);
end;