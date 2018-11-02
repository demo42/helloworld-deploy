#!/bin/sh

set -e
# SP, PASSWORD , CLUSTER_NAME, CLUSTER_RESOURCE_GROUP
az configure --defaults acr=$ACR_NAME

az login \
    --service-principal \
    --username $SP \
    --password $PASSWORD \
    --tenant $TENANT  > /dev/null

echo -- helm init --client-only --
helm init --client-only > /dev/null

echo -- az acr helm repo add --
az acr helm repo add 

echo -- helm package --
helm package \
    --version $APP_VERSION \
    --app-version $RUN_ID \
    ./helm/$APP_NAME

echo -- az acr helm push --
az acr helm push \
    ./$APP_NAME-$APP_VERSION.tgz \
    --force -o table


