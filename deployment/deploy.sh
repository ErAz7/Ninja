#!/bin/sh
set -e

JONIN_HOST="$1"
TARGET_USER="$2"
TARGET_HOST="$3"
PASSWORD="$4"

SSH_OPTS="-o StrictHostKeyChecking=no"
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname "$0")" && pwd)"
PREP_SH="$SCRIPT_DIR/prep.sh"
REMOTE_PREP="/root/prep.sh"

usage() {
    echo "Usage:"
    echo "  deploy.sh JONIN_HOST TARGET_USER TARGET_HOST [PASSWORD]"
    exit 1
}

[ -n "$JONIN_HOST" ] && [ -n "$TARGET_USER" ] && [ -n "$TARGET_HOST" ] || usage

if [ ! -f "$PREP_SH" ]; then
    echo "prep.sh not found in current directory"
    exit 1
fi

REMOTE_CMD="sed -i 's/\r$//' $REMOTE_PREP && chmod +x $REMOTE_PREP && export JONIN_HOST=$JONIN_HOST && $REMOTE_PREP"

echo "Uploading prep.sh..."
if [ -z "$PASSWORD" ]; then
    scp $SSH_OPTS "$PREP_SH" "$TARGET_USER@$TARGET_HOST:$REMOTE_PREP"
else
    sshpass -p "$PASSWORD" scp $SSH_OPTS "$PREP_SH" "$TARGET_USER@$TARGET_HOST:$REMOTE_PREP"
fi

echo "Running prep.sh..."
if [ -z "$PASSWORD" ]; then
    ssh $SSH_OPTS "$TARGET_USER@$TARGET_HOST" "$REMOTE_CMD"
else
    sshpass -p "$PASSWORD" ssh $SSH_OPTS "$TARGET_USER@$TARGET_HOST" "$REMOTE_CMD"
fi
