# =================================== Multi Stage - Compiler Python
FROM maestroserver/standalone-maestro-base AS compiler-python

ENV PYTHONDONTWRITEBYTECODE=1
RUN python3 -m venv /home/app/venv
ENV PATH="/home/app/venv/bin:$PATH"

COPY discovery-api/ /data/discovery-app/
COPY report-app/ /data/report-app/
COPY data-app/ /data/data-app/
COPY analytics-maestro/ /data/analytics-maestro/
COPY scheduler-app/ /data/scheduler-app/
RUN touch /data/scheduler-app/app.schedulers.MongoScheduler.db

RUN pip3 install -r /data/discovery-app/requirements.txt # Discovery App
RUN pip3 install -r /data/report-app/requirements.txt # Report App
RUN pip3 install -r /data/data-app/requirements.txt # Data App
RUN pip3 install -r /data/analytics-maestro/requirements.txt # Analytics App
RUN pip3 install -r /data/scheduler-app/requirements.txt # Schedule App
RUN pip3 install gunicorn

RUN pip3 uninstall -y pyjwt && pip3 install pyjwt # Bug on jwt encode call

# =================================== Multi Stage - Compiler Nodejs
FROM maestroserver/standalone-maestro-base AS compiler-nodejs
# Server App
WORKDIR /data/server-app/
COPY server-app/ ./
RUN npm install --only=production
RUN mkdir -p /data/server-app/public/static/users/ && mkdir -p /data/server-app/public/static/teams/

# Audit App
WORKDIR /data/audit-app/
COPY audit-app/ ./
RUN npm install --only=production

# Analytics Front
WORKDIR /data/analytics-front/
COPY analytics-front/ ./
RUN npm install --only=production

RUN mkdir -p /data/artifacts
RUN mkdir -p /data/analytics-front/public
RUN mkdir -p /data/artifacts/graphs-bussiness

RUN npm --prefix /data/server-app/ install bcrypt


# =================================== Multi Stage - standalone minimal
FROM maestroserver/standalone-maestro-minimal AS standalone-minimal
COPY --from=compiler-python /home/app/venv /home/app/venv
COPY --from=compiler-python /data /data
COPY --from=compiler-nodejs /data /data

# Client App
COPY client-app/nginx/nginx.conf /etc/nginx/nginx.conf
COPY client-app/dist /var/www
COPY client-app/static /var/www/static

# Centrifugo
COPY websocket-app/devtools/centrifugo /usr/local/bin/centrifugo 
COPY websocket-app/devtools/pems/server.key /tmp/certs/server.key
COPY websocket-app/devtools/pems/server.crt /tmp/certs/server.crt

COPY infraascode-maestro/docker-all-in-one/docker-entrypoint.sh /data/docker-entrypoint.sh
RUN chmod +x /data/docker-entrypoint.sh

# Entry point
RUN useradd -s /bin/false nginx
RUN useradd app
RUN chown -R app:app /data/
ENV PATH="/home/app/venv/bin:$PATH"
WORKDIR /data/

COPY infraascode-maestro/docker-all-in-one/supervisord-minimal.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80 443 8888 8000 9999

CMD ["/data/docker-entrypoint.sh"]


# =================================== Multi Stage - standalone
FROM maestroserver/standalone-maestro-services AS standalone 
COPY --from=standalone-minimal /home/app/venv /home/app/venv
COPY --from=standalone-minimal /data /data
COPY --from=standalone-minimal /var/www /var/www
COPY --from=standalone-minimal /etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=standalone-minimal /tmp/certs/ /tmp/certs/
COPY --from=standalone-minimal /usr/local/bin/centrifugo  /usr/local/bin/centrifugo 

# Entry point
RUN useradd -s /bin/false nginx
RUN useradd app
RUN chown -R app:app /data/
ENV PATH="/home/app/venv/bin:$PATH"
RUN mkdir -p /data/db
WORKDIR /data/

COPY infraascode-maestro/docker-all-in-one/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80 443 8888 8000 9999

CMD ["/data/docker-entrypoint.sh"]