#!/bin/sh

if [[ -z "${SKIP_MIGRATION}" ]]; then
  echo "Bootstrapping === "
  node ./server-app/node_modules/mongodb-migrate-maestroserver -runmm -cfg ./server-app/.migration-config.js up
fi

pm2-docker start --json pm2.json
