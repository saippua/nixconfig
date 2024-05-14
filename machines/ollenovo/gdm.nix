{ config, lib, pkgs, ... }:
{
    services.xserver.displayManager.gdm = {
        enable = true;
        wayland = true;
    };

    # Enable display manager from xserver and nothing else.
    systemd.defaultUnit = "graphical.target";
    systemd.services.display-manager =
    let
        cfg = config.services.xserver.displayManager;
    in
    {
        description = "Display Manager";
        after = [ "acpid.service" "systemd-logind.service" ];
        restartIfChanged = false;
        environment =
            lib.optionalAttrs
                config.hardware.opengl.setLdLibraryPath {
                    LD_LIBRARY_PATH = pkgs.addOpenGLRunpath.driverLink;
                } // cfg.job.environment;
        preStart =
        ''
            ${cfg.job.preStart}
            rm -f /tmp/.X0-lock
        '';
    
        script = "${cfg.job.execCmd}";

        serviceConfig = {
            Restart = "always";
            RestartSec = "200ms";
            SyslogIdentifier = "display-manager";
            StartLimitInterval = "30s";
            StartLimitBurst = "3s";
        };
    };
}
