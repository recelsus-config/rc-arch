#!/usr/bin/env bash
set -euo pipefail

user_name="arch"
desired_uid="${USER_UID:-1000}"

if ! id "${user_name}" >/dev/null 2>&1; then
    echo "expected user not found: ${user_name}" >&2
    exit 1
fi

current_uid="$(id -u "${user_name}")"
current_gid="$(id -g "${user_name}")"

if [ "${current_uid}" != "${desired_uid}" ]; then
    usermod -o -u "${desired_uid}" "${user_name}"
fi

if [ -d "/home/${user_name}" ]; then
    if [ "$(stat -c '%u' "/home/${user_name}")" = "${current_uid}" ]; then
        chown "${desired_uid}:${current_gid}" "/home/${user_name}" || true
    fi
    find "/home/${user_name}" -xdev -user "${current_uid}" \
        \( -path "/home/${user_name}/.ssh" -prune -o \
           -exec chown "${desired_uid}:${current_gid}" {} + \) || true
fi

export HOME="/home/${user_name}"

exec sudo -E -H -u "${user_name}" env HOME="${HOME}" PATH="${PATH}" "$@"
