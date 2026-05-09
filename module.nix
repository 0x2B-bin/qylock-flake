{
  flake.nixosModules.qylock = { config, lib, self', ... }:
  let
    cfg = config.programs.qylock;
  in
  {
    options.programs.qylock = {
      enable = lib.mkEnableOption "some txt";
      sddm-theme = lib.mkOption {
        type = lib.types.str;
        description = "Qylock theme to use for SDDM";
        default = "nier-automata";
      };

      sddm-font = lib.mkOption {
        type = lib.types.path;
        description = "Font for SDDM theme";
        default = null;
      };

      lock-theme = lib.mkOption {
        type = lib.types.str;
        description = "Qylock theme to use for lockscreen";
        default = cfg.sddm-theme;
      };

      lock-font = lib.mkOption {
        type = lib.types.path;
        description = "Font for lockscreen";
        default = null;
      };
    };

    config = lib.mkIf cfg.enable (
    let
      qylock-sddm = self'.packages.default.override {
        sddmTheme = cfg.sddm-theme;
        sddmFont = cfg.sddm-font;
        lockscreenTheme = cfg.lock-theme;
        lockscreenFont = cfg.lock-font;
      };

      qylock-lock = self'.packages.default.qylock-lock.override {
        qylock-theme = qylock-sddm;
      };
    in
    {
      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        theme = cfg.sddm-theme;
      };

      environment.systemPackages = [
        qylock-sddm
        qylock-lock
      ];
    });
  };
}
