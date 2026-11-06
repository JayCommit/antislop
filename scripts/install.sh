#!/usr/bin/env bash
# Copy this repository into Agent Skill folders (macOS or Linux).
# Default: --host all --scope user ($HOME). Project scope uses the current directory.
# SKILL.md is placed directly in the skill folder. Existing destinations are refused.
# This script was syntax-checked and path-checked on Linux. It was not run on macOS.

set -euo pipefail

host="all"
scope="user"

usage() {
  cat <<'EOF'
Usage: bash scripts/install.sh [--host HOST] [--scope SCOPE]

Copy this repository into Agent Skill directories so SKILL.md sits directly
inside the skill folder (never antislop/antislop/).

HOST: grok | grok-bot | cursor | openai | antigravity | claude | all
      (default all)
SCOPE: user | project
      user copies under $HOME (default)
      project copies under the current directory

Does not overwrite an existing destination. Skips .git and .verification.
Windows: scripts/install.ps1 with the same flags.
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --help|-h)
      usage
      exit 0
      ;;
    --host)
      shift
      if [ $# -eq 0 ]; then
        echo "Missing value for --host" >&2
        exit 1
      fi
      host="$1"
      ;;
    --host=*)
      host="${1#--host=}"
      ;;
    --scope)
      shift
      if [ $# -eq 0 ]; then
        echo "Missing value for --scope" >&2
        exit 1
      fi
      scope="$1"
      ;;
    --scope=*)
      scope="${1#--scope=}"
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

case "$host" in
  grok|grok-bot|cursor|openai|antigravity|claude|all) ;;
  *)
    echo "Unknown host: $host" >&2
    exit 1
    ;;
esac

case "$scope" in
  user|project) ;;
  *)
    echo "Unknown scope: $scope" >&2
    exit 1
    ;;
esac

source_link="${BASH_SOURCE[0]}"
while [ -L "$source_link" ]; do
  link_dir="$(cd "$(dirname "$source_link")" && pwd)"
  source_link="$(readlink "$source_link")"
  case "$source_link" in
    /*) ;;
    *) source_link="$link_dir/$source_link" ;;
  esac
done
script_dir="$(cd "$(dirname "$source_link")" && pwd)"
repo="$(cd "$script_dir/.." && pwd)"

if [ ! -f "$repo/SKILL.md" ]; then
  echo "SKILL.md not found at repo root: $repo" >&2
  exit 1
fi

if [ "$scope" = "user" ]; then
  if [ -z "${HOME:-}" ]; then
    echo "HOME is not set" >&2
    exit 1
  fi
  root="$HOME"
else
  root="$(pwd)"
fi

# Snapshot before creating destinations. A project install inside this repo
# must not copy the new skill folder back into itself.
items=()
shopt -s dotglob nullglob
for item in "$repo"/*; do
  base="$(basename "$item")"
  case "$base" in
    .git|.verification) continue ;;
  esac
  items[${#items[@]}]="$item"
done
shopt -u dotglob nullglob

if [ "${#items[@]}" -eq 0 ]; then
  echo "Nothing to copy from $repo" >&2
  exit 1
fi

rels=""
add_rel() {
  case " $rels " in
    *" $1 "*) ;;
    *) rels="${rels:+$rels }$1" ;;
  esac
}

add_host_rels() {
  case "$1" in
    grok|grok-bot)
      add_rel ".grok/skills/antislop"
      ;;
    cursor)
      add_rel ".cursor/skills/antislop"
      ;;
    openai)
      add_rel ".agents/skills/antislop"
      ;;
    antigravity)
      if [ "$scope" = "user" ]; then
        add_rel ".gemini/config/skills/antislop"
        add_rel ".gemini/antigravity-cli/skills/antislop"
      else
        add_rel ".agents/skills/antislop"
      fi
      ;;
    claude)
      add_rel ".claude/skills/antislop"
      ;;
  esac
}

if [ "$host" = "all" ]; then
  add_host_rels grok
  add_host_rels grok-bot
  add_host_rels cursor
  add_host_rels openai
  add_host_rels antigravity
  add_host_rels claude
else
  add_host_rels "$host"
fi

if [ -z "$rels" ]; then
  echo "No destinations for host $host" >&2
  exit 1
fi

for rel in $rels; do
  dest="$root/$rel"
  if [ -e "$dest" ]; then
    echo "Installation already exists: $dest" >&2
    exit 1
  fi
done

echo "Installing host=$host scope=$scope from $repo"

copy_one() {
  dest="$1"
  mkdir -p "$dest"
  for item in "${items[@]}"; do
    cp -R "$item" "$dest/"
  done
  if [ ! -f "$dest/SKILL.md" ]; then
    echo "Install failed: $dest/SKILL.md is missing" >&2
    exit 1
  fi
  if [ -e "$dest/antislop/SKILL.md" ]; then
    echo "Install failed: double-nested $dest/antislop/SKILL.md" >&2
    exit 1
  fi
  if [ -e "$dest/.git" ]; then
    echo "Install failed: copied .git into $dest" >&2
    exit 1
  fi
  echo "Installed $dest"
}

for rel in $rels; do
  copy_one "$root/$rel"
done
