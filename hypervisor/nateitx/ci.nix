# Manually save /etc/github-runner-token for first rebuild
{ pkgs, ... }:
{
    services.github-runners.nateitx-hypervisor = {
        enable = true;
        url = "https://github.com/nategiraudeau/natecloud";
        tokenFile = "/etc/github-runner-token";
        extraLabels = [ "hypervisor" ];

        user = "github-runner";
        group = "github-runner";

        extraPackages = [ pkgs.sudo ];
    };

    # sudo needs setuid privileges, which systemd's hardening blocks by default
    systemd.services.github-runner-nateitx-hypervisor.serviceConfig.NoNewPrivileges = false;

    users.groups.github-runner = { };
    users.users.github-runner = {
        isSystemUser = true;
        group = "github-runner";
    };

    # github-runner user has permissions to run nixos-rebuild only
    security.sudo.extraRules = [{
        users = [ "github-runner" ];
        commands = [{
            command = "/run/current-system/sw/bin/nixos-rebuild";
            options = [ "NOPASSWD" ];
        }];
    }];
}
