{
  lib,
  stdenv,
  plymouth,
}:

stdenv.mkDerivation rec {
  pname = "framework-mocha-plymouth-theme";
  version = "0.1.0";

  src = ./.;

  installPhase = ''
    runHook preInstall

    install -d -m 0755 $out/share/plymouth/themes/framework
    cp -r ./framework/* $out/share/plymouth/themes/framework
    substituteInPlace $out/share/plymouth/themes/framework/framework.plymouth \
      --replace "ImageDir=/usr/share/plymouth/themes/framework" "ImageDir=$out/share/plymouth/themes/framework"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Plymouth theme with animated Framework logo";
    homepage = "https://github.com/costeer/framework-mocha-plymouth-theme";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
