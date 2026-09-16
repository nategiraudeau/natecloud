# Manually save /etc/github-runner-token for first rebuild
{ lib, ... }:
{
    services.github-runners.nateitx-hypervisor = {
        enable = true;
        url = "https://github.com/nategiraudeau/natecloud";
        tokenFile = "/etc/github-runner-token";
        extraLabels = [ "hypervisor" ];

        user = "github-runner";
        group = "github-runner";

        # This trusted runner deploys the host
        serviceOverrides = lib.genAttrs [
            "NoNewPrivileges"
            "PrivateUsers"
            "PrivateDevices"
            "PrivateMounts"
            "PrivateTmp"
            "ProtectSystem"
            "ProtectHome"
            "ProtectControlGroups"
            "ProtectClock"
            "ProtectHostname"
            "ProtectKernelTunables"
            "ProtectKernelModules"
            "ProtectKernelLogs"
            "RestrictNamespaces"
            "RestrictRealtime"
            "RestrictSUIDSGID"
        ] (_: false) // {
            CapabilityBoundingSet = lib.mkForce [ "~" ];
            SystemCallFilter = lib.mkForce [ ];
            RestrictAddressFamilies = lib.mkForce [ ];
        };
    };

    systemd.services.github-runner-nateitx-hypervisor = {
        path = lib.mkBefore [ "/run/wrappers" "/run/current-system/sw" ];
        
        # Keep the current job alive during activation
        restartIfChanged = false;
        stopIfChanged = false;
    };

    users.groups.github-runner = { };
    users.users.github-runner = {
        isSystemUser = true;
        group = "github-runner";
    };

    security.sudo.extraConfig = ''
        Defaults:github-runner env_keep += "SSH_PUBLIC_KEY"
    '';
    # github-runner user has sudo permissions to run nixos-rebuild only
    security.sudo.extraRules = [{
        users = [ "github-runner" ];
        commands = [{
            command = "/run/current-system/sw/bin/nixos-rebuild";
            options = [ "NOPASSWD" ];
        }];
    }];
}
