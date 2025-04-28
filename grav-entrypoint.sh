#!/bin/sh
set -e

# Update Grav core and plugins if available
cd /var/www/grav
if [ -x ./bin/gpm ]; then
    echo "Updating Grav core..."
    ./bin/gpm selfupgrade -f || true
    echo "Updating Grav plugins..."
    ./bin/gpm update -f || true
else
    echo "gpm not found, skipping Grav updates."
fi

# Execute the original CMD (default: /init-admin)
exec "$@"
