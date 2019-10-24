FROM demo-maestro-base

# Server App
WORKDIR /data/server-app/

COPY server-app/app/ ./app/
COPY server-app/templates ./templates/
COPY server-app/migrations ./migrations/
COPY server-app/.migration-config.js .
COPY server-app/package.json .
COPY server-app/server.js .

RUN mkdir -p /data/public/static/users/ && mkdir -p /data/public/static/teams/

RUN npm install --only=production
RUN npm rebuild bcrypt --build-from-source

# Entry point
WORKDIR /data/

COPY pm2.json .
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/sbin/tini","-g","--"]
CMD ["docker-entrypoint.sh"]