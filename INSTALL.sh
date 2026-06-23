#!/usr/bin/env bash
# Ensures fd, zoxide, fzf, rg are installed.
# fd/rg use the system package manager (brew/apt/dnf/yum/pacman/zypper/apk).
# zoxide and fzf use their upstream installers.

set -euo pipefail

# Package name per manager. Format: cmd|brew|apt|dnf|pacman|zypper|apk
# Use "-" when the manager does not ship the tool under a usable name.
TOOLS=(
  "fd|fd|fd-find|fd-find|fd|fd|fd"
  "rg|ripgrep|ripgrep|ripgrep|ripgrep|ripgrep|ripgrep"
)

# Tools installed outside the package manager; still verified at the end.
EXTRA_CMDS=(zoxide fzf)

SUDO=""
maybe_sudo() {
  if [[ $EUID -ne 0 ]] && command -v sudo >/dev/null 2>&1; then
    SUDO="sudo"
  fi
}

detect_pm() {
  if [[ "$(uname -s)" == "Darwin" ]]; then
    if command -v brew >/dev/null 2>&1; then echo "brew"; return; fi
    echo "Homebrew is required on macOS. Install from https://brew.sh" >&2
    exit 1
  fi
  for pm in apt-get dnf yum pacman zypper apk; do
    if command -v "$pm" >/dev/null 2>&1; then
      case "$pm" in
        apt-get) echo "apt" ;;
        yum)     echo "yum" ;;
        *)       echo "$pm" ;;
      esac
      return
    fi
  done
  echo "No supported package manager found (brew/apt/dnf/yum/pacman/zypper/apk)." >&2
  exit 1
}

pkg_field_index() {
  case "$1" in
    brew)   echo 2 ;;
    apt)    echo 3 ;;
    dnf|yum) echo 4 ;;
    pacman) echo 5 ;;
    zypper) echo 6 ;;
    apk)    echo 7 ;;
  esac
}

refresh_index() {
  case "$1" in
    apt)    $SUDO apt-get update ;;
    dnf)    : ;;
    yum)    : ;;
    pacman) $SUDO pacman -Sy --noconfirm ;;
    zypper) $SUDO zypper --non-interactive refresh ;;
    apk)    $SUDO apk update ;;
    brew)   brew update ;;
  esac
}

install_pkg() {
  local pm="$1" pkg="$2"
  case "$pm" in
    brew)   brew install "$pkg" ;;
    apt)    $SUDO apt-get install -y "$pkg" ;;
    dnf)    $SUDO dnf install -y "$pkg" ;;
    yum)    $SUDO yum install -y "$pkg" ;;
    pacman) $SUDO pacman -S --noconfirm --needed "$pkg" ;;
    zypper) $SUDO zypper --non-interactive install "$pkg" ;;
    apk)    $SUDO apk add "$pkg" ;;
  esac
}

is_installed() {
  local cmd="$1"
  if command -v "$cmd" >/dev/null 2>&1; then
    return 0
  fi
  # fd ships as `fdfind` on Debian/Ubuntu; accept that as installed.
  if [[ "$cmd" == "fd" ]] && command -v fdfind >/dev/null 2>&1; then
    return 0
  fi
  return 1
}

# `fzf --bash` (used in our .bashrc setup) was added in fzf 0.48.0.
FZF_MIN_MAJOR=0
FZF_MIN_MINOR=48
fzf_supports_bash_init() {
  local ver major minor
  ver=$(fzf --version 2>/dev/null | awk '{print $1}')
  if [[ -z "$ver" ]]; then
    return 1
  fi
  IFS=. read -r major minor _ <<<"$ver"
  major=${major:-0}
  minor=${minor:-0}
  if (( major > FZF_MIN_MAJOR || (major == FZF_MIN_MAJOR && minor >= FZF_MIN_MINOR) )); then
    return 0
  fi
  return 1
}

missing_entries=()
for entry in "${TOOLS[@]}"; do
  IFS='|' read -r -a fields <<<"$entry"
  cmd="${fields[0]}"
  if is_installed "$cmd"; then
    echo "$cmd: already installed ($(command -v "$cmd" 2>/dev/null || command -v fdfind))"
  else
    missing_entries+=("$entry")
  fi
done

if (( ${#missing_entries[@]} > 0 )); then
  maybe_sudo
  PM="$(detect_pm)"
  IDX="$(pkg_field_index "$PM")"
  echo "Using package manager: $PM"

  refresh_index "$PM"

  for entry in "${missing_entries[@]}"; do
    IFS='|' read -r -a fields <<<"$entry"
    cmd="${fields[0]}"
    pkg="${fields[$((IDX - 1))]}"

    if [[ -z "$pkg" || "$pkg" == "-" ]]; then
      echo "$cmd: no package mapping for $PM — skipping" >&2
      continue
    fi

    echo "$cmd: installing '$pkg' via $PM..."
    install_pkg "$PM" "$pkg"
  done
fi

if is_installed zoxide; then
  echo "zoxide: already installed ($(command -v zoxide))"
elif command -v curl >/dev/null 2>&1; then
  echo "zoxide: installing via upstream installer..."
  curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
else
  echo "zoxide: curl not on PATH — skipping" >&2
fi

# zoxide's installer drops the binary in ~/.local/bin — make sure it's on PATH.
LOCAL_BIN="${HOME}/.local/bin"
PATH_LINE='export PATH="$HOME/.local/bin:$PATH"'
if [[ -d "$LOCAL_BIN" ]]; then
  case ":$PATH:" in
    *":$LOCAL_BIN:"*) ;;
    *) export PATH="$LOCAL_BIN:$PATH" ;;
  esac
  rc="${HOME}/.bashrc"
  if [[ -f "$rc" ]] && grep -Fq "$PATH_LINE" "$rc"; then
    echo "~/.local/bin: already on PATH in $rc"
  else
    { echo ""; echo "# Ensure ~/.local/bin is on PATH"; echo "$PATH_LINE"; } >> "$rc"
    echo "Appended ~/.local/bin PATH setup to $rc"
  fi
fi

FZF_DIR="${HOME}/.fzf"
if is_installed fzf && fzf_supports_bash_init; then
  echo "fzf: already installed ($(command -v fzf), $(fzf --version | awk '{print $1}'))"
elif command -v git >/dev/null 2>&1; then
  if is_installed fzf; then
    echo "fzf: existing version $(fzf --version | awk '{print $1}') is older than ${FZF_MIN_MAJOR}.${FZF_MIN_MINOR} (needed for 'fzf --bash'); reinstalling via git..."
  fi
  if [[ ! -d "$FZF_DIR" ]]; then
    echo "fzf: cloning into $FZF_DIR..."
    git clone --depth 1 https://github.com/junegunn/fzf.git "$FZF_DIR"
  fi
  echo "fzf: running installer..."
  "$FZF_DIR/install" --key-bindings --completion --no-update-rc
else
  echo "fzf: git not on PATH — skipping" >&2
fi

# fzf's installer puts the binary at ~/.fzf/bin — make sure it's on PATH.
FZF_BIN="${FZF_DIR}/bin"
FZF_PATH_LINE='export PATH="$HOME/.fzf/bin:$PATH"'
if [[ -d "$FZF_BIN" ]]; then
  case ":$PATH:" in
    *":$FZF_BIN:"*) ;;
    *) export PATH="$FZF_BIN:$PATH" ;;
  esac
  rc="${HOME}/.bashrc"
  if [[ -f "$rc" ]] && grep -Fq "$FZF_PATH_LINE" "$rc"; then
    echo "~/.fzf/bin: already on PATH in $rc"
  else
    { echo ""; echo "# Ensure ~/.fzf/bin is on PATH"; echo "$FZF_PATH_LINE"; } >> "$rc"
    echo "Appended ~/.fzf/bin PATH setup to $rc"
  fi
fi

append_bashrc_block() {
  local cmd="$1" comment="$2" line="$3"
  local rc="${HOME}/.bashrc"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "$cmd not on PATH — skipping bashrc setup" >&2
    return
  fi
  SHELL_INITS+=("$line")
  if [[ -f "$rc" ]] && grep -Fq "$line" "$rc"; then
    echo "$cmd: already configured in $rc"
    return
  fi
  {
    echo ""
    echo "$comment"
    echo "$line"
  } >> "$rc"
  echo "Appended $cmd setup to $rc"
}

SHELL_INITS=()

append_bashrc_block fzf \
  "# Set up fzf key bindings and fuzzy completion" \
  'eval "$(fzf --bash)"'

append_bashrc_block zoxide \
  "# Set up zoxide (cd replacement)" \
  'eval "$(zoxide init bash)"'

echo
echo "Verifying..."
missing=0
verify_cmds=()
for entry in "${TOOLS[@]}"; do
  IFS='|' read -r cmd _rest <<<"$entry"
  verify_cmds+=("$cmd")
done
verify_cmds+=("${EXTRA_CMDS[@]}")

for cmd in "${verify_cmds[@]}"; do
  if command -v "$cmd" >/dev/null 2>&1; then
    echo "  ok: $cmd -> $(command -v "$cmd")"
  elif [[ "$cmd" == "fd" ]] && command -v fdfind >/dev/null 2>&1; then
    echo "  ok: fd available as 'fdfind' -> $(command -v fdfind)"
  else
    echo "  MISSING: $cmd"
    missing=1
  fi
done

TPM_DIR="${HOME}/.tmux/plugins/tpm"
if [[ -d "$TPM_DIR" ]]; then
  echo "tpm: already installed at $TPM_DIR"
elif command -v git >/dev/null 2>&1; then
  echo "tpm: cloning into $TPM_DIR..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
  echo "tpm: git not on PATH — skipping" >&2
fi

if (( ${#SHELL_INITS[@]} > 0 )); then
  echo
  echo "To enable in the current shell, run:"
  for line in "${SHELL_INITS[@]}"; do
    echo "  $line"
  done
fi

exit "$missing"
