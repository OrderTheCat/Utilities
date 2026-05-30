#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"

DNF_SRC="$REPO_ROOT/dnf/dnf.conf"
DNF_DEST="/etc/dnf/dnf.conf"
TOPGRADE_SRC="$REPO_ROOT/topgrade.toml"
TOPGRADE_DEST="$HOME/.config/topgrade.toml"

usage() {
  cat <<USAGE
Usage: $0 [--help] [--dry-run]

Install repository configuration files:
  - $DNF_SRC -> $DNF_DEST
  - $TOPGRADE_SRC -> $TOPGRADE_DEST

Options:
  --dry-run  Show what would be installed without writing files.
  --help     Show this help message.
USAGE
}

log() {
  printf '%s\n' "$*"
}

die() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

run() {
  if [ "$DRY_RUN" = true ]; then
    log "DRY RUN: $*"
  else
    eval "$*"
  fi
}

check_source() {
  [ -f "$1" ] || die "Missing source file: $1"
}

install_file() {
  local src="$1"
  local dest="$2"
  local dest_dir
  dest_dir="$(dirname "$dest")"

  log "Installing $src -> $dest"
  if [ "$DRY_RUN" = true ]; then
    log "DRY RUN: create directory $dest_dir"
    log "DRY RUN: copy $src to $dest"
    return
  fi

  if [ "$EUID" -ne 0 ] && ! command -v sudo >/dev/null 2>&1; then
    die "Root privileges are required to write $dest. Install sudo or run this script as root."
  fi

  if [ ! -d "$dest_dir" ]; then
    if [ "$EUID" -eq 0 ]; then
      mkdir -p "$dest_dir"
    else
      sudo mkdir -p "$dest_dir"
    fi
  fi

  if [ "$EUID" -eq 0 ]; then
    cp -f "$src" "$dest"
  else
    sudo cp -f "$src" "$dest"
  fi
}

main() {
  DRY_RUN=false

  while [ "$#" -gt 0 ]; do
    case "$1" in
      --help|-h)
        usage
        exit 0
        ;;
      --dry-run)
        DRY_RUN=true
        shift
        ;;
      *)
        die "Unknown argument: $1"
        ;;
    esac
  done

  check_source "$DNF_SRC"
  check_source "$TOPGRADE_SRC"

  install_file "$DNF_SRC" "$DNF_DEST"
  install_file "$TOPGRADE_SRC" "$TOPGRADE_DEST"

  log "Installation complete."
}

main "$@"
