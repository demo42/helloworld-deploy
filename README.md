# helloworld-deploy

Repository used to Package and Push a Helm Chart for the https://github.com/demo42/helloworld sample repo


See [../helloworld/README.md](../helloworld/README.md) for setup information

## Helm Package/Push Helm Charts
```sh
az acr run \
  -f acr-task.yaml \
  . \
  --set CLUSTER_NAME=$AKS_CLUSTER_NAME \
  --set CLUSTER_RESOURCE_GROUP=$AKS_RESOURCE_GROUP \
  --set SP=$(az keyvault secret show \
            --vault-name ${AKV_NAME} \
            --name $ACR_NAME-serviceaccount-user \
            --query value -o tsv) \
  --set PASSWORD=$(az keyvault secret show \
            --vault-name ${AKV_NAME} \
            --name $ACR_NAME-serviceaccount-pwd \
            --query value -o tsv) \
  --set TENANT=$(az keyvault secret show \
            --vault-name ${AKV_NAME} \
            --name $ACR_NAME-tenant \
            --query value -o tsv) \
  --registry $ACR_NAME 
```

## Task to maintain the helm chart
az acr task create \
    -n hellowworld-helm-chart \
    -c $GIT_DEPLOY_REPO \
    --git-access-token $(az keyvault secret show \
                    --vault-name $AKV_NAME \
                    --name $GIT_TOKEN_NAME \
                    --query value -o tsv) \
    -f acr-task.yaml \
    --set CLUSTER_NAME=$AKS_CLUSTER_NAME \
    --set CLUSTER_RESOURCE_GROUP=$AKS_RESOURCE_GROUP \
    --set TENANT=$(az keyvault secret show \
                    --vault-name ${AKV_NAME} \
                    --name $ACR_NAME-tenant \
                    --query value -o tsv) \
    --set-secret SP=$(az keyvault secret show \
                --vault-name ${AKV_NAME} \
                --name $ACR_NAME-serviceaccount-user \
                --query value -o tsv) \
    --set-secret PASSWORD=$(az keyvault secret show \
                    --vault-name ${AKV_NAME} \
                    --name $ACR_NAME-serviceaccount-pwd \
                    --query value -o tsv) \
  --registry $ACR_NAME 
