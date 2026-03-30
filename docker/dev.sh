#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
compose_file="${script_dir}/docker-compose.dev.yml"

if [ ! -f "${compose_file}" ]; then
    echo "compose file not found: ${compose_file}" >&2
    exit 1
fi

compose_cmd=(docker compose -f "${compose_file}")

existing_container="$(${compose_cmd[@]} ps -q || true)"

if [ -n "${existing_container}" ]; then
    read -rp "rc-arch is running. Run down? [y/N] " answer
    if [[ ! "${answer}" =~ ^[Yy]$ ]]; then
        echo "aborted"
        exit 0
    fi
    ${compose_cmd[@]} down --remove-orphans
fi

${compose_cmd[@]} build

read -rp "Run up -d? [y/N] " answer
if [[ ! "${answer}" =~ ^[Yy]$ ]]; then
    echo "skip up"
    exit 0
fi

${compose_cmd[@]} up -d
