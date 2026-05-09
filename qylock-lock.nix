{
  pkgs,
  qylock-theme
}:
let
  qylock-theme-name = qylock-theme.lockscreenTheme;
in
pkgs.writeShellApplication {
  name = "qylock-lock";

  runtimeInputs = with pkgs; [
    quickshell
    qt6.qtdeclarative
    qt6.qtmultimedia
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
  ];

  text = ''
    export QML2_IMPORT_PATH="${pkgs.qt6.qtmultimedia}/lib/qt-6/qml:${pkgs.qt6.qtdeclarative}/lib/qt-6/qml"
    export QML2_IMPORT_PATH="$QML2_IMPORT_PATH:${pkgs.qt6.qt5compat}/lib/qt-6/qml:${pkgs.qt6.qtsvg}/lib/qt-6/qml"
    export QML2_IMPORT_PATH="$QML2_IMPORT_PATH:${pkgs.kdePackages.sddm}/lib/qt-6/qml"

    export GST_PLUGIN_SYSTEM_PATH_1_0="${pkgs.gst_all_1.gst-plugins-base}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-good}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-bad}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-ugly}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-libav}/lib/gstreamer-1.0"

    export XDG_SESSION_TYPE=wayland
    export QS_THEME=${qylock-theme-name}
    export QS_THEME_PATH=${qylock-theme}/share/sddm/themes/${qylock-theme-name}
    export QUICKSHELL_DEBUG_WSI=1

    killall -9 hyprlock swaylock wlogout 2>/dev/null || true
    quickshell -p ${qylock-theme}/share/quickshell/qylock/lock_shell.qml
  '';
}
