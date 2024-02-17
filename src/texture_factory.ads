with Ada.Strings.Unbounded;
with Textures; use Textures;

package Texture_Factory is
    function procure_texture(requested_texture : String) return Texture_Access;
end Texture_Factory;