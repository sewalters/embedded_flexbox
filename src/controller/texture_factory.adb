with Textures; use Textures;
with Textures.Ada; use Textures.Ada;
with Textures.Spark; use Textures.Spark;
with Textures.Lady_Ada; use Textures.Lady_Ada;

package body Texture_Factory is
    function procure_texture(requested_texture : String) return Texture_Access is
        text_acc : Texture_Access;
        type images is (Ada, Spark, Lady_Ada);
    begin
        case images'Value(requested_texture) is
        when Ada =>
            text_acc := Textures.Ada.Bmp'Access;
        when Spark =>
            text_acc := Textures.Spark.Bmp'Access;
        when Lady_Ada =>
            text_acc := Textures.Lady_Ada.Bmp'Access;
        when others =>
            text_acc := Textures.Ada.Bmp'Access;
        end case;
        return text_acc;
    end procure_texture;
end Texture_Factory;