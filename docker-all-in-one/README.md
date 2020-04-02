
# Standalone maestro

Builder files to make the docker standalone.

Standalone maestro is the easy way to spin up a new maestro service. Simple like
```
docker run -p 80:80 -p 8888:8888 -p 5000:5000 -p 8000:8000 -p 9999:9999 standalone-maestro
```

Open the browser and access localhost.

You can add any env variables as described on maestro project as:
```
docker run
    -p 80:80 
    -p 8888:8888 
    -p 5000:5000 
    -p 8000:8000 
    -p 9999:9999 
    -e API_URL=https://mydomain.com
    standalone-maestro
```

The most important envs are:
- **API_URL:** Server App Url 
- **ANALYTICS_URL:** Analytics app url [Same as server]
- **WEBSOCKET_URL:** Websocket url [Same as api]
- **MAESTRO_MONGO_URI:** Mongo db [Can connect on a external db]
- **MAESTRO_MONGO_DATABASE:** Mongo db name

Avoid to use 
- **MAESTRO_PORT:** This var set the port in each service, however standalone spin up all services in a single hosts.



## Build
To build the image, 

1 - To be ensure to have all services cloned:
2 - Copy the infraascode/docker-all-in-one/Dockerfile to ./

Folder structure:
```
cd maestro/

- analytics-maestro/
- client-app/
- discovery-api/
- report-app/
- server-app/
- analytics-front/
- audit-app/
- data-app/
- scheduler-app/
- websocket-app/
- infraascode-maestro/

Dockerfile # File copied
```

```
cd maestro/
docker build -f Dockerfile -t "standalone-maestro" .
```