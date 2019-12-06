FROM demo-maestro-base

# Client App
RUN useradd -s /bin/false nginx

COPY client-app/nginx/nginx.conf /etc/nginx/nginx.conf
COPY client-app/dist /var/www
COPY client-app/static /var/www/static

# Server App
WORKDIR /data/server-app/

COPY server-app/app/ ./app/
COPY server-app/templates ./templates/
COPY server-app/migrations ./migrations/
COPY server-app/.migration-config.js .
COPY server-app/package.json .
COPY server-app/server.js .

RUN mkdir -p /data/server-app/public/static/users/ && mkdir -p /data/public/static/teams/

RUN npm install --only=production

# Discovery App
WORKDIR /data/discovery-app/

COPY discovery-api/app ./app/
COPY discovery-api/instance ./instance/
COPY discovery-api/requirements.txt .
COPY discovery-api/package.json .
COPY discovery-api/run.py .
COPY discovery-api/gunicorn_config.py .

RUN pip3 install -r requirements.txt

# Report App
WORKDIR /data/report-app/

COPY report-app/app ./app/
COPY report-app/instance ./instance/
COPY report-app/requirements.txt .
COPY report-app/package.json .
COPY report-app/run.py .
COPY report-app/gunicorn_config.py .

RUN pip3 install -r requirements.txt

# Data App
WORKDIR /data/data-app/

COPY data-app/app ./app/
COPY data-app/instance ./instance/
COPY data-app/requirements.txt .
COPY data-app/package.json .
COPY data-app/run.py .
COPY data-app/gunicorn_config.py .

RUN pip3 install -r requirements.txt

# Analytics App
WORKDIR /data/analytics-maestro/

COPY analytics-maestro/app ./app/
COPY analytics-maestro/instance ./instance/
COPY analytics-maestro/requirements.txt .
COPY analytics-maestro/package.json .
COPY analytics-maestro/run.py .
COPY analytics-maestro/gunicorn_config.py .

RUN pip3 install -r requirements.txt

# Analytics Front
WORKDIR /data/analytics-front/

COPY analytics-front/app/ ./app/
COPY analytics-front/package.json .
COPY analytics-front/server.js .

RUN mkdir -p /data/analytics-front/artifacts/graphs-bussiness
RUN mkdir -p /data/analytics-front/public

RUN npm install --only=production

# Schedule App
WORKDIR /data/scheduler-app/

COPY scheduler-app/app ./app/
COPY scheduler-app/instance ./instance/
COPY scheduler-app/requirements.txt .
COPY scheduler-app/package.json .
COPY scheduler-app/run.py .

RUN pip3 install -r requirements.txt

# Centrifugo

# Audit App
WORKDIR /data/audit-app/

COPY audit-app/app/ ./app/
COPY audit-app/package.json .
COPY audit-app/server.js .

RUN npm install --only=production


RUN pip3 uninstall --yes pyjwt
RUN yes | pip3 install pyjwt

# Entry point
RUN useradd app
WORKDIR /data/

RUN pip3 install gunicorn

COPY docker-entrypoint.sh .
RUN chmod +x /data/docker-entrypoint.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80 443 8888

CMD ["/data/docker-entrypoint.sh"]