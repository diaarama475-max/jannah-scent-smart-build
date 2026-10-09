#!/usr/bin/env bash
# First install on a new server (as root):
#   curl -fsSL https://raw.githubusercontent.com/diaarama475-max/jannah-scent-smart-build/main/get.sh | bash -s -- [install.sh options]
# Downloads the latest build, checks its signature with the key below, and runs its installer.
set -euo pipefail
REPO="${JANNAH_BUILD_REPO:-diaarama475-max/jannah-scent-smart-build}"
KEY='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOLyYNxEhcpfRltkgQ2tajRJI81V+w6yHZuQzUdCbUSU'
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
command -v curl >/dev/null || { apt-get update -qq && apt-get install -y -qq curl ca-certificates; }
ver=$(curl -fsSL "https://github.com/$REPO/releases/latest/download/latest.json" | grep -oE '"version" *: *"[0-9.]+"' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
f="$tmp/jannah-$ver.tar.gz"
curl -fsSL -o "$f" "https://github.com/$REPO/releases/download/v$ver/jannah-$ver.tar.gz"
curl -fsSL -o "$f.sig" "https://github.com/$REPO/releases/download/v$ver/jannah-$ver.tar.gz.sig"
echo "jannah-release $KEY" > "$tmp/allowed_signers"
ssh-keygen -Y verify -f "$tmp/allowed_signers" -I jannah-release -n jannah-release -s "$f.sig" < "$f" >/dev/null || { echo "BAD SIGNATURE — stopped"; exit 1; }
tar -C "$tmp" -xzf "$f"
bash "$tmp/jannah-$ver/deploy/install.sh" --tarball "$f" "$@"
