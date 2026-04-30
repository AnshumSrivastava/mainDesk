{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nodejs_20
    (corepack.overrideAttrs (old: { doCheck = false; }))
    nodePackages.pnpm
    typescript
    nodePackages.svelte-check
    nodePackages.svelte-language-server
    nodePackages.typescript-language-server
    
    # Build Essentials for native node modules
    gcc
    gnumake
    python3
    pkg-config
    openssl
  ];

  # Enable corepack for pnpm/yarn management
  environment.variables = {
    COREPACK_ENABLE_STRICT = "0";
  };
}
