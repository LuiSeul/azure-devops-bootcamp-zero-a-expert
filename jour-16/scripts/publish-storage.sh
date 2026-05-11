#!/bin/bash
# publish-storage.sh

set -e

MODULE_NAME="storage"
MODULE_VERSION=${1:-"1.0.0"} 
ACR_NAME=${ACR_NAME:-"tfmodules"}
ACR_LOGIN_SERVER="${ACR_NAME}.azurecr.io"

echo "📦 Publication du module $MODULE_NAME v$MODULE_VERSION"

# Vérification des prérequis
command -v oras >/dev/null 2>&1 || { echo "❌ ORAS requis"; exit 1; }

# Connexion ACR
az acr login --name $ACR_NAME

# Création du package OCI
TEMP_DIR=$(mktemp -d)
cp -r modules/$MODULE_NAME/* $TEMP_DIR/

# Création du manifeste
cd $TEMP_DIR
cat > manifest.json << EOF
{
  "schemaVersion": 2,
  "mediaType": "application/vnd.oci.image.manifest.v1+json"
}
EOF

# Création de l'artifact OCI
tar -czf module.tar.gz main.tf variables.tf outputs.tf versions.tf

# Publication avec ORAS
oras push $ACR_LOGIN_SERVER/terraform/modules/$MODULE_NAME:$MODULE_VERSION \
    --artifact-type "application/vnd.terraform.module.v1+json" \
    module.tar.gz:application/vnd.terraform.module.layer.v1.tar+gzip \
    --annotation "org.opencontainers.image.title=$MODULE_NAME" \
    --annotation "org.opencontainers.image.version=$MODULE_VERSION" \
    --annotation "com.terraform.provider=azurerm"

cd -
rm -rf $TEMP_DIR

echo "✅ Module publié : $ACR_LOGIN_SERVER/terraform/modules/$MODULE_NAME:$MODULE_VERSION"

# Test de récupération
oras manifest fetch $ACR_LOGIN_SERVER/terraform/modules/$MODULE_NAME:$MODULE_VERSION | jq '.'