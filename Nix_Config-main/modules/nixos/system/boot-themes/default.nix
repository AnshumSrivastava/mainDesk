{ pkgs, ... }:

{
  progeta-plymouth = pkgs.stdenv.mkDerivation {
    pname = "progeta-plymouth";
    version = "1.0";

    src = ./plymouth;

    installPhase = ''
      mkdir -p $out/share/plymouth/themes/progeta
      cp * $out/share/plymouth/themes/progeta/

      sed -i "s|@out@|$out|g" $out/share/plymouth/themes/progeta/progeta.plymouth
    '';
  };

  progeta-grub = pkgs.stdenv.mkDerivation {
    pname = "progeta-grub";
    version = "1.0";

    src = ./grub;

    installPhase = ''
      mkdir -p $out/grub/themes/progeta
      cp * $out/grub/themes/progeta/
    '';
  };
}
