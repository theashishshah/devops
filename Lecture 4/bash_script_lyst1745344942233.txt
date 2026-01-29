#!/usr/bin/env bash
set -euo pipefail

# Usage check
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <username>"
  exit 1
fi

USERNAME="$1"
HOME_DIR="/home/$USERNAME"
SSH_DIR="$HOME_DIR/.ssh"
KEY_NAME="id_rsa"

# 1. Create the user if it doesn't already exist
if id "$USERNAME" &>/dev/null; then
  echo "User '$USERNAME' already exists, skipping useradd."
else
  echo "Creating user '$USERNAME' with home directory..."
  useradd -m -s /bin/bash "$USERNAME"
fi

# 2. Ensure the .ssh directory exists with correct permissions
echo "Setting up SSH directory..."
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"
chown "$USERNAME":"$USERNAME" "$SSH_DIR"

# 3. Generate an SSH keypair (no passphrase)
KEY_PATH="$SSH_DIR/$KEY_NAME"
if [ -f "$KEY_PATH" ]; then
  echo "Key $KEY_PATH already exists, skipping ssh-keygen."
else
  echo "Generating SSH keypair for $USERNAME..."
  ssh-keygen -t rsa -b 2048 -f "$KEY_PATH" -N "" -C "$USERNAME@$(hostname)"
  chown "$USERNAME":"$USERNAME" "${KEY_PATH}" "${KEY_PATH}.pub"
  chmod 600 "${KEY_PATH}"
  chmod 644 "${KEY_PATH}.pub"
fi

# 4. Install the public key into authorized_keys
echo "Installing public key into authorized_keys..."
cat "${KEY_PATH}.pub" > "$SSH_DIR/authorized_keys"
chmod 600 "$SSH_DIR/authorized_keys"
chown "$USERNAME":"$USERNAME" "$SSH_DIR/authorized_keys"

# 5. Output the private key
echo
echo "=== Private key for $USERNAME ==="
cat "$KEY_PATH"
echo "================================="
