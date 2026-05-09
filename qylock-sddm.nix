{
  stdenvNoCC,
  sddmTheme ? "nier-automata",
  sddmFont ? null,
  lockscreenTheme ? sddmTheme,
  lockscreenFont ? null,
}:
stdenvNoCC.mkDerivation ( finalAttrs: {
  name = "qylock";

  src = fetchGit {
    url = "https://github.com/Darkkal44/qylock.git";
    rev = "bece4d25a9dcd043a072847c8ed92dca3800616e";
  };

  installPhase = ''
    mkdir -p $out/share/sddm/themes/${sddmTheme}/font
    mkdir -p $out/share/quickshell/qylock

    cp -r ./themes/${sddmTheme} $out/share/sddm/themes
    cp -r ./Assets $out/share/sddm/themes/${sddmTheme}
    cp -r ./quickshell-lockscreen/* $out/share/quickshell/qylock

    ${if sddmTheme != lockscreenTheme then ''
      cp -r ./themes/${lockscreenTheme} $out/share/sddm/themes
      cp -r ./Assets $out/share/sddm/themes/${lockscreenTheme}
    '' else ""}

    ${if sddmFont != null then ''
      mkdir -p $out/share/sddm/themes/${sddmTheme}/font
      cp "${sddmFont}" $out/share/sddm/themes/${sddmTheme}/font/
    '' else ""}

    ${if lockscreenFont != null then ''
      mkdir -p $out/share/sddm/themes/${lockscreenTheme}/font
      cp "${lockscreenFont}" $out/share/sddm/themes/${lockscreenTheme}/font/
    '' else ""}

  '';

  passthru = {
    inherit lockscreenTheme;
  };
})
