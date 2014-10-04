#!/bin/bash

configFile='
bind 127.0.0.1
dir {{=service.env.PIO_SERVICE_DATA_BASE_PATH}}
'
echo "$configFile" | sudo tee $PIO_SCRIPTS_PATH/redis.conf

mkdir -p $PIO_SERVICE_DATA_BASE_PATH || true


initScript='
description "{{=service.env.PIO_SERVICE_ID_SAFE}}"

start on local-filesystems
stop on shutdown

script
    echo $$ > {{=service.env.PIO_SERVICE_RUN_BASE_PATH}}.pid
    # TODO: All requested environment variables should be declared dynamically.
    export PATH={{=service.env.PATH}}
    export PORT={{=service.env.PORT}}
    cd {{=service.env.PIO_SERVICE_PATH}}/live/install
    export PIO_SERVICE_DATA_BASE_PATH={{=service.env.PIO_SERVICE_DATA_BASE_PATH}}
    exec {{=service.env.PIO_SERVICE_PATH}}/live/install/redis/src/redis-server '$PIO_SCRIPTS_PATH'/redis.conf >> {{=service.env.PIO_SERVICE_LOG_BASE_PATH}}.log 2>&1
end script

pre-start script
    echo "\\n\\n['`date -u +%Y-%m-%dT%T.%3NZ`'] (/etc/init/app-{{=service.env.PIO_SERVICE_ID_SAFE}}.conf) ########## STARTING ##########\\n" >> {{=service.env.PIO_SERVICE_LOG_BASE_PATH}}.log
end script

pre-stop script
    rm -f {{=service.env.PIO_SERVICE_RUN_BASE_PATH}}.pid
    echo "\\n['`date -u +%Y-%m-%dT%T.%3NZ`'] (/etc/init/app-{{=service.env.PIO_SERVICE_ID_SAFE}}.conf) ^^^^^^^^^^ STOPPING ^^^^^^^^^^\\n\\n" >> {{=service.env.PIO_SERVICE_LOG_BASE_PATH}}.log
end script
'
if [ -f "/etc/init/app-$PIO_SERVICE_ID_SAFE.conf" ]; then
    sudo stop app-$PIO_SERVICE_ID_SAFE || true
fi
echo "$initScript" | sudo tee /etc/init/app-$PIO_SERVICE_ID_SAFE.conf
sudo start app-$PIO_SERVICE_ID_SAFE
