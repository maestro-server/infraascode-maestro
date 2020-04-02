#!/bin/sh

# Nginx
VURL=${API_URL:='http://localhost:8888'}
sed -i "s#api_url content=[[:alnum:]\/:\.]*#api_url content=$VURL#" /var/www/index.html
VAL=${ANALYTICS_URL:='http://localhost:9999'}
sed -i "s#analytics_url content=[[:alnum:]\/:\.]*#analytics_url content=$VAL#" /var/www/index.html
VAL=${WEBSOCKET_URL:='ws://localhost:8000'}
sed -i "s#websocket_url content=[[:alnum:]\/:\.]*#websocket_url content=$VAL#" /var/www/index.html
VSTATIC=${STATIC_URL:='/upload/'}
sed -i "s#static_url content=[[:alnum:]\/:\.]*#static_url content=$VSTATIC#" /var/www/index.html
VLOGO=${LOGO:='/static/imgs/logo300.png'}
sed -i "s#logo_url content=[[:alnum:]\/:\.]*#logo_url content=$VLOGO#" /var/www/index.html
VTHEME=${THEME:='lotus'}
sed -i "s#theme content=[[:alnum:]\/:\.]*#theme content=$VTHEME#" /var/www/index.html


# Centrifugo
VSECRET=${MAESTRO_SECRETJWT:='defaultSecretKey'}
VAPIPKEY=${MAESTRO_WEBSOCKET_SECRET:='wsSecretKey'}

VADMIN=$CENTRIFUGO_ADMIN
VADSECRET=$CENTRIFUGO_ADMIN_SECRET
VADMIN=${VADMIN:='-'}
VADSECRET=${VADSECRET:='-'}
TLSPORT=${CENTRIFUGO_TLS_PORT:=':80'}

CWPATH="/config.json"

jq -n\
 --arg secret $VSECRET\
 --arg api_key $VAPIPKEY\
 --arg admin_password $VADMIN\
 --arg admin_secret $VADSECRET\
 '{"secret":$secret, "api_key":$api_key, "admin_password":$admin_password, "admin_secret":$admin_secret}' > $CWPATH


if [ -z ${CENTRIFUGO_TLSAUTO} ];
    then
        echo "-> TlsAuto disabled"
    else
        echo "-> TlsAuto enabled"
        TMPJ=$(jq '.tls_autocert=true | .tls_autocert_cache_dir = "\/tmp\/certs"' $CWPATH)
        echo $TMPJ > $CWPATH
fi

if [ -z ${CENTRIFUGO_DEVTLS} ];
    then
        echo "-> DevTls disabled"
    else
        echo "-> DevTls enabled"
        TMPJ=$(jq '.tls=true | .tls_key="\/tmp\/certs\/server.key" | .tls_cert="\/tmp\/certs\/server.crt"' $CWPATH)
        echo $TMPJ > $CWPATH
fi


# spin up supervisord
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf