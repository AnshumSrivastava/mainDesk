#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════════╗
# ║  mainDesktop — NixOS Bootstrap Script                           ║
# ║  Run this on a fresh NixOS install to deploy the full config.   ║
# ╚══════════════════════════════════════════════════════════════════╝
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

REPO_URL="https://github.com/AnshumSrivastava/Nix_Config.git"
CONFIG_DIR="$HOME/nixos-config"
FLAKE_DIR="$CONFIG_DIR/mainDesktop"
HOST="mainDesktop"

log()  { echo -e "${BLUE}[INFO]${NC} $1"; }
ok()   { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[✗]${NC} $1"; exit 1; }

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║          mainDesktop — NixOS Bootstrap                      ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# ── Step 1: Enable flakes (temporary) ─────────────────────────────
log "Step 1/7: Ensuring flakes are enabled..."
if ! nix --version 2>/dev/null | grep -q "nix"; then
  err "Nix is not installed. Please install NixOS first."
fi

export NIX_CONFIG="experimental-features = nix-command flakes"
ok "Flakes enabled for this session"

# ── Step 2: Clone or update repo ──────────────────────────────────
log "Step 2/7: Setting up configuration repository..."
if [ -d "$CONFIG_DIR" ]; then
  warn "Repository already exists at $CONFIG_DIR"
  log "Pulling latest changes..."
  git -C "$CONFIG_DIR" pull --rebase || warn "Pull failed, using existing"
else
  log "Cloning repository..."
  git clone "$REPO_URL" "$CONFIG_DIR"
fi
ok "Repository ready at $CONFIG_DIR"

# ── Step 3: Copy hardware configuration ───────────────────────────
log "Step 3/7: Merging hardware configuration..."
NIXOS_HW="/etc/nixos/hardware-configuration.nix"
TARGET_HW="$FLAKE_DIR/hosts/main/hardware-generated.nix"

if [ -f "$NIXOS_HW" ]; then
  cp "$NIXOS_HW" "$TARGET_HW"
  ok "Copied $NIXOS_HW → $TARGET_HW"
  warn "Review $TARGET_HW and merge any needed kernel modules into hardware.nix"
else
  warn "No $NIXOS_HW found — run 'nixos-generate-config' first if on new hardware"
fi

# ── Step 4: Create /mnt/system directory structure ────────────────
log "Step 4/7: Creating /mnt/system directory structure..."
SYSTEM_DIRS=(
  "/mnt/system/nix"
  "/mnt/system/var-cache"
  "/mnt/system/var-tmp"
  "/mnt/system/docker"
  "/mnt/system/containers"
  "/mnt/system/libvirt"
  "/mnt/system/cache"
  "/mnt/system/Notes"
  "/mnt/system/home/$USER/Downloads"
  "/mnt/system/home/$USER/Documents"
  "/mnt/system/home/$USER/Music"
  "/mnt/system/home/$USER/Pictures"
  "/mnt/system/home/$USER/Videos"
  "/mnt/system/home/$USER/Desktop"
)

for dir in "${SYSTEM_DIRS[@]}"; do
  if [ ! -d "$dir" ]; then
    sudo mkdir -p "$dir"
    sudo chown "$USER:users" "$dir"
    log "  Created $dir"
  fi
done
ok "Directory structure ready"

# ── Step 5: Set up SOPS age key from SSH ──────────────────────────
log "Step 5/7: Setting up SOPS encryption key..."
AGE_KEY_DIR="$HOME/.config/sops/age"
AGE_KEY_FILE="$AGE_KEY_DIR/keys.txt"

if [ -f "$AGE_KEY_FILE" ]; then
  ok "Age key already exists at $AGE_KEY_FILE"
else
  SSH_KEY="$HOME/.ssh/id_ed25519"
  if [ -f "$SSH_KEY" ]; then
    mkdir -p "$AGE_KEY_DIR"
    nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i $SSH_KEY > $AGE_KEY_FILE"
    chmod 600 "$AGE_KEY_FILE"
    ok "Generated age key from SSH key"

    # Show public key for .sops.yaml
    PUB_KEY=$(nix-shell -p ssh-to-age --run "ssh-to-age < ${SSH_KEY}.pub")
    echo ""
    warn "Your age PUBLIC key (put this in secrets/.sops.yaml):"
    echo -e "  ${GREEN}$PUB_KEY${NC}"
    echo ""
  else
    warn "No SSH key found at $SSH_KEY"
    log "Generating a new ed25519 SSH key..."
    ssh-keygen -t ed25519 -f "$SSH_KEY" -N ""
    mkdir -p "$AGE_KEY_DIR"
    nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i $SSH_KEY > $AGE_KEY_FILE"
    chmod 600 "$AGE_KEY_FILE"
    PUB_KEY=$(nix-shell -p ssh-to-age --run "ssh-to-age < ${SSH_KEY}.pub")
    ok "Generated new SSH key and age key"
    echo ""
    warn "Your age PUBLIC key (put this in secrets/.sops.yaml):"
    echo -e "  ${GREEN}$PUB_KEY${NC}"
    echo ""
  fi
fi

# ── Step 6: Build and switch ──────────────────────────────────────
log "Step 6/7: Building NixOS configuration..."
echo ""
echo "  This may take a while on the first build."
echo "  Hyprland will be fetched from cachix (pre-built)."
echo ""

sudo nixos-rebuild switch --flake "path:${FLAKE_DIR}#${HOST}"
ok "NixOS configuration applied!"

# ── Step 7: Post-install checklist ────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  ✓ Bootstrap Complete!                                      ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "  Post-install checklist:"
echo "  ───────────────────────"
echo "  1. Update secrets/.sops.yaml with your age public key"
echo "  2. Encrypt secrets:  cd $FLAKE_DIR && sops --encrypt --in-place secrets/secrets.yaml"
echo "  3. Configure Syncthing:  http://localhost:8384"
echo "  4. Log in to Tailscale:  sudo tailscale up"
echo "  5. Log in to Bitwarden"
echo "  6. Set up Git:  edit home/user/programs/git.nix"
echo "  7. Reboot to apply all changes:  sudo reboot"
echo ""
