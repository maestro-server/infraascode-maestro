#!/bin/bash

# Client
INDEX_PATH="/var/www/index.html"
VARS=("api_url" "analytics_url" "websocket_url" "static_url" "logo_url" "theme")
ENVS=("API_URL" "ANALYTICS_URL" "WEBSOCKET_URL" "STATIC_URL" "LOGO" "THEME")

for i in "${!VARS[@]}"; do
 
    # Reset all vars
    sed -i "" "s#<meta name='${VARS[$i]}' content='[[:alnum:]\/:\.\ _]*'>#<!-- ${VARS[$i]} -->#" $INDEX_PATH

    # If a env vars exit put the value on meta tag
    if [ -n "${!ENVS[$i]}" ];
    then
        sed -i "" "s#<!-- ${VARS[$i]} -->#<meta name='${VARS[$i]}' content='${!ENVS[$i]}'>#" $INDEX_PATH
    fi
done


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