#!/usr/bin/env bash

set -euo pipefail

TEMP_PASSWORD="password"

usage() {
    echo "Usage:"
    echo "  $0 user@example.com"
    echo "  $0 emails.txt"
    exit 1
}

# Must be run as root
if [[ $EUID -ne 0 ]]; then
    echo "Error: run this script with sudo."
    exit 1
fi

if [[ $# -ne 1 ]]; then
    usage
fi

INPUT="$1"

create_user() {
    local email="$1"
    local username

    # Trim whitespace
    email="$(echo "$email" | xargs)"

    # Ignore blank lines
    [[ -z "$email" ]] && return

    # Basic email check
    if [[ ! "$email" =~ ^([^@[:space:]]+)@([^@[:space:]]+)$ ]]; then
        echo "SKIP: Invalid email: $email"
        return
    fi

    # Extract everything before @
    username="${email%@*}"

    # Linux username policy:
    # - Start with a lowercase letter or underscore
    # - Remaining characters: lowercase letters, numbers, _, -
    #
    # Convert uppercase to lowercase
    username="$(echo "$username" | tr '[:upper:]' '[:lower:]')"

    # Replace characters that aren't safe with underscores
    username="$(echo "$username" | sed 's/[^a-z0-9_-]/_/g')"

    # Linux usernames should not start with a number or hyphen.
    # Prefix with "user_" if necessary.
    if [[ ! "$username" =~ ^[a-z_] ]]; then
        username="user_$username"
    fi

    # Collapse repeated underscores
    username="$(echo "$username" | sed 's/__*/_/g')"

    # Remove trailing hyphens/underscores
    username="${username%%[-_]}"
    
    # Make sure something remains
    if [[ -z "$username" ]]; then
        echo "SKIP: Could not create a valid username from: $email"
        return
    fi

    # Linux username length limit
    if [[ ${#username} -gt 32 ]]; then
        echo "SKIP: Username too long: $username ($email)"
        return
    fi

    # Final safety check
    if [[ ! "$username" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
        echo "SKIP: Generated username is not Linux-safe: $username"
        return
    fi

    # Don't modify an existing account
    if id "$username" &>/dev/null; then
        echo "EXISTS: $username ($email)"
        return
    fi

    echo "CREATE: $username <- $email"

    # Create the Ubuntu account
    useradd \
        --create-home \
        --shell /bin/bash \
        --groups plugdev \
        "$username"

    # Set temporary password
    echo "$username:$TEMP_PASSWORD" | chpasswd

    # Force password change on first login
    chage --lastday 0 "$username"

    echo "  Created successfully."
}

# Single email
if [[ "$INPUT" == *"@"* ]]; then
    create_user "$INPUT"
    exit 0
fi

# File containing one email per line
if [[ -f "$INPUT" ]]; then
    while IFS= read -r email || [[ -n "$email" ]]; do
        create_user "$email"
    done < "$INPUT"
    exit 0
fi

echo "Error: '$INPUT' is not an email address or readable file."
exit 1
