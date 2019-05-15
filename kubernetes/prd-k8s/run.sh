#bin/bash

kubectl apply -f mongo/
kubectl apply -f rabbitmq/
kubectl apply -f maildev/
kubectl apply -f maestro-websocket/
kubectl apply -f maestro-data/
kubectl apply -f maestro-discovery/
kubectl apply -f maestro-reports/
kubectl apply -f maestro-analytics/
kubectl apply -f maestro-analytics-front/
kubectl apply -f maestro-audit/
kubectl apply -f maestro-scheduler/
kubectl apply -f maestro-server/
kubectl apply -f maestro-client/