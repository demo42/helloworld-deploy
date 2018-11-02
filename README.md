# helloworld-deploy
Repository used to Package and Push a Helm Chart for the https://github.com/demo42/helloworld sample repo


See [../helloworld/README.md](../helloworld/README.md) for setup information

## Helm Package/Push Helm Charts
```sh
az acr run \
  -f acr-task.yaml . \
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