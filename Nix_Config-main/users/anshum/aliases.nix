{ config, pkgs, ... }:

let
  variables = import ./variables.nix;

  clear-prev = pkgs.writeShellScriptBin "clear-prev" ''
    echo "Identifying current and initial system generations..."
    # nix-env lists generations. We want to keep 1 and current.
    # A safer approach is to use nix-env --delete-generations with a specific list, 
    # but the cleanest supported way is to keep a specific number of profiles or use a profile GC.
    # To delete everything EXCEPT the first and current, we can script it:
    
    current_gen=$(sudo nix-env -p /nix/var/nix/profiles/system --list-generations | grep current | awk '{print $1}')
    
    if [ -z "$current_gen" ]; then
        echo "Could not determine current generation."
        exit 1
    fi
    
    echo "Current System Generation: $current_gen"
    echo "Keeping Generation 1 and Generation $current_gen..."
    
    # +1 and +$current_gen are special syntax for nix-env to KEEP those specific generations and delete the rest
    # However, nix-env --delete-generations expects the ones to DELETE.
    # Let's get all generation numbers
    all_gens=$(sudo nix-env -p /nix/var/nix/profiles/system --list-generations | awk '{print $1}')
    
    gens_to_delete=""
    for gen in $all_gens; do
        if [ "$gen" != "1" ] && [ "$gen" != "$current_gen" ]; then
            gens_to_delete="$gens_to_delete $gen"
        fi
    done
    
    if [ -n "$gens_to_delete" ]; then
        echo "Deleting generations:$gens_to_delete"
        sudo nix-env -p /nix/var/nix/profiles/system --delete-generations $gens_to_delete
    else
        echo "No extra generations to delete."
    fi
    
    echo "Collecting garbage (freeing space)..."
    sudo nix-collect-garbage -d
  '';

in
{
  environment.systemPackages = with pkgs; [
    clear-prev
  ];

  environment.shellAliases = {
    switch-config = "sudo nixos-rebuild switch --flake path:/home/anshum/nixos-config#nixos";
    # adding other aliases here
    update-deps = "nix flake update";
    garbage-collect = "sudo nix-collect-garbage -d";
  };
}
