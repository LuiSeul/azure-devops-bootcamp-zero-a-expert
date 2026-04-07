# Formation Complète : Azure Resource Manager (ARM) & Infrastructure as Code

## Sommaire

1. [Qu’est-ce que l’Infrastructure as Code ? (What)](#1-quest-ce-que-linfrastructure-as-code--what)
2. [Les trois piliers de l’IaC sur Azure](#2-les-trois-piliers-de-liac-sur-azure)
   - 2.1 ARM Templates (JSON)
   - 2.2 Bicep
   - 2.3 Terraform
   - 2.4 Tableau comparatif
3. [Structure fondamentale d’un template ARM](#3-structure-fondamentale-dun-template-arm)
   - 3.1 Le fichier JSON
   - 3.2 Les sections obligatoires
4. [Paramètres, variables et fonctions](#4-paramètres-variables-et-fonctions)
5. [Déploiement d’un template ARM](#5-déploiement-dun-template-arm)
   - 5.1 Azure CLI
   - 5.2 Azure PowerShell
   - 5.3 Portail Azure
6. [Gestion du cycle de vie : créer, modifier, supprimer](#6-gestion-du-cycle-de-vie--créer-modifier-supprimer)
   - 6.1 Déploiement complet
   - 6.2 Mode incrémental (par défaut) vs mode complet
   - 6.3 Suppression des ressources
7. [Exemples pratiques pas à pas](#7-exemples-pratiques-pas-à-pas)
   - 7.1 Template 1 : Création d’un compte de stockage
   - 7.2 Template 2 : Création d’une machine virtuelle complète (VNet, NSG, IP publique, VM)
   - 7.3 Template 3 : Utilisation des paramètres pour personnaliser le déploiement
8. [Outils essentiels pour travailler avec les templates](#8-outils-essentiels-pour-travailler-avec-les-templates)
   - 8.1 Visual Studio Code
   - 8.2 Extensions VS Code incontournables
   - 8.3 Azure Resource Manager Tools for VS Code
   - 8.4 Bicep extension
   - 8.5 Azure CLI
   - 8.6 ARM Template Toolkit
9. [Bonnes pratiques professionnelles](#9-bonnes-pratiques-professionnelles)
   - 9.1 Limites à connaître
   - 9.2 Sémantique et maintenabilité
   - 9.3 Validation avant déploiement
   - 9.4 Sécurité des secrets
10. [Conclusion](#10-conclusion)

---

## 1. Qu’est-ce que l’Infrastructure as Code ? (What)

L’**Infrastructure as Code (IaC)** est une pratique DevOps qui consiste à gérer et provisionner l’infrastructure à l’aide de fichiers de configuration, au lieu d’utiliser des interfaces graphiques ou des commandes manuelles.

Avec l’IaC, vous décrivez ce que doit être votre infrastructure (machines virtuelles, réseaux, bases de données, etc.) dans un fichier texte. Ce fichier devient la source de vérité. Vous pouvez le versionner (Git), le faire relire, le tester, et le déployer de manière reproductible.

### Pourquoi l’IaC est indispensable en entreprise ?

- **Reproductibilité** : le même fichier produit la même infrastructure partout (développement, recette, production)
- **Auditabilité** : chaque modification est tracée dans Git
- **Réduction des erreurs** : plus de clics manuels ou de commandes oubliées
- **Rapidité** : déployer une infrastructure complète en quelques minutes
- **Automatisation CI/CD** : intégration dans les pipelines Azure DevOps ou GitHub Actions

---

## 2. Les trois piliers de l’IaC sur Azure

Azure propose trois approches principales pour l’IaC. Chacune a ses forces et ses cas d’usage.

### 2.1 ARM Templates (JSON)

Les **ARM templates** sont le format historique d’Azure. Ce sont des fichiers JSON qui décrivent exactement les ressources à déployer, avec leur configuration.

```
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.Storage/storageAccounts",
      "apiVersion": "2023-01-01",
      "name": "moncomptestockage",
      "location": "francecentral",
      "sku": { "name": "Standard_LRS" },
      "kind": "StorageV2"
    }
  ]
}
```

### 2.2 Bicep

**Bicep** est un langage DSL (Domain-Specific Language) introduit par Microsoft pour simplifier l’écriture des templates ARM. Un fichier Bicep est converti (transpilé) en ARM JSON avant d’être envoyé à Azure.

```
param storageAccountName string
param location string = resourceGroup().location

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: { name: 'Standard_LRS' }
  kind: 'StorageV2'
}
```

### 2.3 Terraform

**Terraform** (HashiCorp) est un outil IaC multi-cloud. Contrairement à ARM et Bicep qui sont spécifiques à Azure, Terraform peut gérer simultanément AWS, Azure, GCP, et des services SaaS.

### 2.4 Tableau comparatif

| Critère | ARM Templates (JSON) | Bicep | Terraform |
| :--- | :--- | :--- | :--- |
| **Type** | JSON | DSL (transpilé en ARM) | HCL (multi-cloud) |
| **Lisibilité** | Verbose, technique | Propre, concise | Déclarative, standardisée |
| **État** | Stateless (déclaratif pur) | Stateless | Stateful (état stocké) |
| **Apprentissage** | JSON à maîtriser | Facile (2-3 jours) | Courbe modérée |
| **Multi-cloud** | Non (Azure uniquement) | Non (Azure uniquement) | Oui |
| **Recommandation Microsoft** | Hérité | Recommandé pour Azure | Alternative légitime |
| **Cas d’usage** | Templates existants, intégrations profondes | Tous les nouveaux projets Azure | Multi-cloud, gestion d’état avancée |

> À retenir : **Bicep** est le langage recommandé par Microsoft pour tout nouveau projet Azure. **ARM JSON** reste utile pour comprendre le fonctionnement interne et pour utiliser des templates existants. **Terraform** est le choix naturel si votre organisation utilise plusieurs clouds.

---

## 3. Structure fondamentale d’un template ARM

### 3.1 Le fichier JSON

Un template ARM est un fichier JSON. Sa structure est normalisée.

### 3.2 Les sections obligatoires

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {},
  "variables": {},
  "resources": [],
  "outputs": {}
}
```

| Section | Rôle |
| :--- | :--- |
| `$schema` | Version du langage ARM (obligatoire) |
| `contentVersion` | Version sémantique de votre template |
| `parameters` | Valeurs fournies au moment du déploiement (ex: nom de l’environnement, taille de VM) |
| `variables` | Valeurs calculées localement, réutilisables dans le template |
| `resources` | Liste des ressources Azure à créer (obligatoire) |
| `outputs` | Valeurs retournées après déploiement (ex: IP publique, URL) |

---

## 4. Paramètres, variables et fonctions

### Paramètres (`parameters`)

Les paramètres permettent de rendre un template réutilisable. On les définit ainsi :

```json
"parameters": {
  "storageAccountName": {
    "type": "string",
    "minLength": 3,
    "maxLength": 24,
    "metadata": {
      "description": "Nom du compte de stockage (3-24 caractères, minuscules et chiffres)"
    }
  },
  "location": {
    "type": "string",
    "defaultValue": "francecentral",
    "metadata": {
      "description": "Région Azure du déploiement"
    }
  },
  "environmentType": {
    "type": "string",
    "allowedValues": [ "dev", "test", "prod" ],
    "defaultValue": "dev"
  }
}
```

### Variables (`variables`)

Les variables contiennent des expressions calculées. Elles évitent la duplication.

```json
"variables": {
  "storageAccountType": "[if(equals(parameters('environmentType'), 'prod'), 'Standard_GRS', 'Standard_LRS')]",
  "tags": {
    "Environment": "[parameters('environmentType')]",
    "DeployedBy": "ARM Template"
  }
}
```

### Fonctions ARM courantes

| Fonction | Exemple | Description |
| :--- | :--- | :--- |
| `concat()` | `concat('storage', parameters('suffixe'))` | Concatène plusieurs chaînes |
| `parameters()` | `parameters('location')` | Récupère la valeur d’un paramètre |
| `variables()` | `variables('storageAccountType')` | Récupère la valeur d’une variable |
| `resourceGroup()` | `resourceGroup().location` | Propriétés du groupe de ressources |
| `subscription()` | `subscription().subscriptionId` | Propriétés de l’abonnement |
| `uniqueString()` | `uniqueString(resourceGroup().id)` | Génère une chaîne unique basée sur l’ID du groupe |
| `if()` | `if(condition, trueValue, falseValue)` | Condition ternaire |

### Référence à une ressource (`reference` et `resourceId`)

```json
"outputs": {
  "storageAccountId": {
    "type": "string",
    "value": "[resourceId('Microsoft.Storage/storageAccounts', variables('storageAccountName'))]"
  }
}
```

---

## 5. Déploiement d’un template ARM

### 5.1 Azure CLI

```bash
# Déploiement au niveau du groupe de ressources
az deployment group create \
  --resource-group MonGroupe \
  --template-file template.json \
  --parameters param1=valeur1 param2=valeur2

# Avec un fichier de paramètres séparé
az deployment group create \
  --resource-group MonGroupe \
  --template-file template.json \
  --parameters parameters.json
```

### 5.2 Azure PowerShell

```powershell
New-AzResourceGroupDeployment `
  -ResourceGroupName MonGroupe `
  -TemplateFile template.json `
  -storageAccountName "moncompte"
```

### 5.3 Portail Azure

Depuis le portail : **Créer une ressource** > **Déploiement de modèle** (utiliser un modèle personnalisé). Collez le contenu JSON et suivez l’assistant.

### Fichier de paramètres séparé (`parameters.json`)

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "storageAccountName": {
      "value": "moncompteproductique"
    },
    "environmentType": {
      "value": "prod"
    }
  }
}
```

---

## 6. Gestion du cycle de vie : créer, modifier, supprimer

### 6.1 Déploiement complet

Lorsque vous exécutez un déploiement, ARM compare l’état cible (décrit dans le template) avec l’état réel. Les ressources sont créées si elles n’existent pas, mises à jour si elles existent déjà.

### 6.2 Mode incrémental (par défaut) vs mode complet

ARM propose deux modes de déploiement :

- **Incremental (défaut)** : les ressources déjà présentes mais absentes du template restent intactes.
- **Complete** : les ressources présentes mais absentes du template sont supprimées.

```bash
az deployment group create \
  --resource-group MonGroupe \
  --template-file template.json \
  --mode Complete
```

> ⚠️ Attention : le mode complet peut supprimer des ressources. À utiliser avec précaution, uniquement pour des déploiements maîtrisés (environnement de test complet).

### 6.3 Suppression des ressources

Pour supprimer des ressources, deux approches :

1. **Supprimer directement la ressource** (ARM template ne sert pas à ça)
   ```bash
   az storage account delete --name moncompte --resource-group MonGroupe
   ```

2. **Supprimer tout le groupe de ressources** (destruction complète de l’environnement)
   ```bash
   az group delete --name MonGroupe
   ```

3. **Déployer un template qui ne contient plus la ressource** avec le mode complet. Mais cette méthode est risquée et déconseillée en production.

> À retenir : un template ARM **crée ou met à jour** des ressources. La suppression d’une ressource spécifique se fait généralement via une commande dédiée, pas via le template.

---

## 7. Exemples pratiques pas à pas

### 7.1 Template 1 : Création d’un compte de stockage

Créez un fichier `storage-template.json` :

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "storageAccountName": {
      "type": "string",
      "metadata": {
        "description": "Nom du compte de stockage (globalement unique)"
      }
    },
    "location": {
      "type": "string",
      "defaultValue": "[resourceGroup().location]"
    },
    "sku": {
      "type": "string",
      "defaultValue": "Standard_LRS",
      "allowedValues": [ "Standard_LRS", "Standard_GRS", "Premium_LRS" ]
    }
  },
  "variables": {
    "tags": {
      "Environment": "dev",
      "CreatedWith": "ARM"
    }
  },
  "resources": [
    {
      "type": "Microsoft.Storage/storageAccounts",
      "apiVersion": "2023-01-01",
      "name": "[parameters('storageAccountName')]",
      "location": "[parameters('location')]",
      "tags": "[variables('tags')]",
      "sku": {
        "name": "[parameters('sku')]"
      },
      "kind": "StorageV2"
    }
  ],
  "outputs": {
    "storageAccountId": {
      "type": "string",
      "value": "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccountName'))]"
    }
  }
}
```

**Déploiement :**

```bash
# Créer le groupe de ressources s’il n’existe pas
az group create --name rg-storage-demo --location francecentral

# Déployer le template
az deployment group create \
  --resource-group rg-storage-demo \
  --template-file storage-template.json \
  --parameters storageAccountName=monstorageunique
```

### 7.2 Template 2 : Création d’une machine virtuelle complète

Un template ARM peut définir plusieurs ressources interdépendantes : réseau virtuel, sous‑réseau, IP publique, groupe de sécurité réseau, carte réseau, et enfin la VM elle‑même.

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "vmName": { "type": "string" },
    "adminUsername": { "type": "string" },
    "adminPassword": { "type": "securestring" },
    "location": { "type": "string", "defaultValue": "[resourceGroup().location]" }
  },
  "variables": {
    "vnetName": "[concat(parameters('vmName'), '-vnet')]",
    "subnetName": "default",
    "publicIpName": "[concat(parameters('vmName'), '-pip')]",
    "nsgName": "[concat(parameters('vmName'), '-nsg')]",
    "nicName": "[concat(parameters('vmName'), '-nic')]"
  },
  "resources": [
    {
      "type": "Microsoft.Network/networkSecurityGroups",
      "apiVersion": "2023-02-01",
      "name": "[variables('nsgName')]",
      "location": "[parameters('location')]",
      "properties": {
        "securityRules": [
          {
            "name": "SSH",
            "properties": {
              "protocol": "Tcp",
              "sourcePortRange": "*",
              "destinationPortRange": "22",
              "sourceAddressPrefix": "*",
              "destinationAddressPrefix": "*",
              "access": "Allow",
              "priority": 100,
              "direction": "Inbound"
            }
          }
        ]
      }
    },
    {
      "type": "Microsoft.Network/publicIPAddresses",
      "apiVersion": "2023-02-01",
      "name": "[variables('publicIpName')]",
      "location": "[parameters('location')]",
      "sku": { "name": "Basic" },
      "properties": { "publicIPAllocationMethod": "Dynamic" }
    },
    {
      "type": "Microsoft.Network/virtualNetworks",
      "apiVersion": "2023-02-01",
      "name": "[variables('vnetName')]",
      "location": "[parameters('location')]",
      "properties": {
        "addressSpace": { "addressPrefixes": [ "10.0.0.0/16" ] },
        "subnets": [
          {
            "name": "[variables('subnetName')]",
            "properties": { "addressPrefix": "10.0.1.0/24" }
          }
        ]
      }
    },
    {
      "type": "Microsoft.Network/networkInterfaces",
      "apiVersion": "2023-02-01",
      "name": "[variables('nicName')]",
      "location": "[parameters('location')]",
      "dependsOn": [
        "[resourceId('Microsoft.Network/publicIPAddresses', variables('publicIpName'))]",
        "[resourceId('Microsoft.Network/virtualNetworks', variables('vnetName'))]",
        "[resourceId('Microsoft.Network/networkSecurityGroups', variables('nsgName'))]"
      ],
      "properties": {
        "ipConfigurations": [
          {
            "name": "ipconfig1",
            "properties": {
              "privateIPAllocationMethod": "Dynamic",
              "publicIPAddress": {
                "id": "[resourceId('Microsoft.Network/publicIPAddresses', variables('publicIpName'))]"
              },
              "subnet": {
                "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', variables('vnetName'), variables('subnetName'))]"
              }
            }
          }
        ],
        "networkSecurityGroup": {
          "id": "[resourceId('Microsoft.Network/networkSecurityGroups', variables('nsgName'))]"
        }
      }
    },
    {
      "type": "Microsoft.Compute/virtualMachines",
      "apiVersion": "2023-03-01",
      "name": "[parameters('vmName')]",
      "location": "[parameters('location')]",
      "dependsOn": [
        "[resourceId('Microsoft.Network/networkInterfaces', variables('nicName'))]"
      ],
      "properties": {
        "hardwareProfile": { "vmSize": "Standard_B1s" },
        "storageProfile": {
          "imageReference": {
            "publisher": "Canonical",
            "offer": "UbuntuServer",
            "sku": "22.04-LTS",
            "version": "latest"
          },
          "osDisk": {
            "name": "[concat(parameters('vmName'), '-osdisk')]",
            "caching": "ReadWrite",
            "createOption": "FromImage"
          }
        },
        "osProfile": {
          "computerName": "[parameters('vmName')]",
          "adminUsername": "[parameters('adminUsername')]",
          "adminPassword": "[parameters('adminPassword')]"
        },
        "networkProfile": {
          "networkInterfaces": [
            {
              "id": "[resourceId('Microsoft.Network/networkInterfaces', variables('nicName'))]"
            }
          ]
        }
      }
    }
  ]
}
```

**Déploiement :**

```bash
az deployment group create \
  --resource-group rg-vm-demo \
  --template-file vm-template.json \
  --parameters vmName=mavmtest adminUsername=azureuser adminPassword=VotreMotDePasseSecurise
```

### 7.3 Template 3 : Utilisation des paramètres pour personnaliser le déploiement

Pour gérer plusieurs environnements (dev, test, prod) avec le même template, créez des fichiers de paramètres distincts.

`parameters-dev.json` :

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "environmentType": { "value": "dev" },
    "vmSize": { "value": "Standard_B1s" },
    "storageAccountSku": { "value": "Standard_LRS" }
  }
}
```

`parameters-prod.json` :

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "environmentType": { "value": "prod" },
    "vmSize": { "value": "Standard_D2s_v3" },
    "storageAccountSku": { "value": "Standard_GRS" }
  }
}
```

---

## 8. Outils essentiels pour travailler avec les templates

### 8.1 Visual Studio Code

VS Code est l’éditeur de référence pour travailler avec les templates Azure. Léger, extensible et gratuit.

### 8.2 Extensions VS Code incontournables

| Extension | Rôle | Installation |
| :--- | :--- | :--- |
| **Azure Resource Manager Tools** | Syntaxe JSON, validation, snippets, aperçu des ressources | `azurerm-tools` |
| **Bicep** | Support complet du langage Bicep (autocomplétion, validation, compilation) | `ms-azuretools.vscode-bicep` |
| **Azure CLI Tools** | Intégration de la ligne de commande Azure | `ms-vscode.azurecli` |
| **Azure Account** | Connexion à votre abonnement Azure directement depuis VS Code | `ms-vscode.azure-account` |

### 8.3 Azure Resource Manager Tools for VS Code

Cette extension offre :

- **Coloration syntaxique** pour les fichiers ARM JSON
- **Snippets** pour accélérer l’écriture (tapez `arm!` puis Tab)
- **Validation en direct** des schémas et des références
- **Aperçu des ressources** (Plan view)
- **Go to Definition** pour les paramètres et variables

### 8.4 Bicep extension

L’extension Bicep est indispensable si vous utilisez Bicep. Elle fournit :

- Autocomplétion intelligente des types de ressources
- Validation des noms de propriétés
- Compilation instantanée vers ARM JSON
- Déploiement direct depuis l’éditeur

### 8.5 Azure CLI

Azure CLI est l’outil de ligne de commande officiel. Les commandes `az deployment` sont essentielles pour automatiser les déploiements.

### 8.6 ARM Template Toolkit

Outil de validation des bonnes pratiques :

```bash
# Installation
npm install -g @microsoft/arm-ttk

# Exécution
Test-AzTemplate -TemplatePath ./template.json
```

---

## 9. Bonnes pratiques professionnelles

### 9.1 Limites à connaître

| Limite | Valeur |
| :--- | :--- |
| Taille totale du template (après expansion) | 4 MB |
| Taille d’une ressource | 1 MB |
| Nombre de ressources par template | 800 |
| Niveau d’imbrication maximum | 5 |

### 9.2 Sémantique et maintenabilité

- **Nommage cohérent** : utilisez des préfixes standardisés (`vm-`, `stg-`, `vnet-`, etc.)
- **Paramétrage systématique** : ne codez jamais en dur des noms ou des tailles. Utilisez des paramètres.
- **Séparation des paramètres** : stockez les valeurs sensibles (mots de passe) dans un fichier de paramètres distinct, jamais dans le template.
- **Modules** : pour les architectures complexes, découpez le template en templates liés (linked templates) ou utilisez Bicep modules.

### 9.3 Validation avant déploiement

Trois étapes indispensables avant tout déploiement en production :

```bash
# 1. Validation syntaxique
az deployment group validate \
  --resource-group MonGroupe \
  --template-file template.json \
  --parameters parameters.json

# 2. Simulation (what-if) : voir les changements sans les appliquer
az deployment group what-if \
  --resource-group MonGroupe \
  --template-file template.json \
  --parameters parameters.json

# 3. Lancer le déploiement
az deployment group create \
  --resource-group MonGroupe \
  --template-file template.json \
  --parameters parameters.json
```

### 9.4 Sécurité des secrets

- Utilisez le type de paramètre `securestring` pour les mots de passe et clés
- Ne versionnez jamais de secrets en clair dans Git
- Pour la production, intégrez **Azure Key Vault** pour récupérer les secrets dynamiquement

```json
"parameters": {
  "adminPassword": {
    "type": "securestring",
    "metadata": {
      "description": "Mot de passe administrateur (récupéré depuis Key Vault)"
    }
  }
}
```

---

## 10. Conclusion

La maîtrise d’Azure Resource Manager et des templates est une compétence fondamentale pour tout professionnel Azure. Que vous choisissiez ARM JSON, Bicep ou Terraform, l’important est d’adopter une approche Infrastructure as Code.

### Synthèse des choix d’outils

| Situation | Recommandation |
| :--- | :--- |
| Nouveau projet Azure | Bicep (recommandé par Microsoft) |
| Projet existant avec templates JSON | Conserver ARM JSON, migrer progressivement |
| Organisation multi-cloud | Terraform |
| Intégration avec Azure DevOps CI/CD | Bicep ou ARM JSON |
| Besoin d’état et de planification avancée | Terraform |

### Pour aller plus loin avec VS Code

1. Installez les extensions Azure Resource Manager Tools et Bicep
2. Connectez‑vous à votre abonnement Azure (`Ctrl+Shift+P` > Azure: Sign In`)
3. Créez un nouveau fichier `main.bicep` (ou `.json`) et commencez à taper : l’autocomplétion vous guide
4. Utilisez le raccourci `F1` > `Bicep: Deploy Bicep File` pour déployer directement

Avec ces bases solides, vous êtes désormais capable de déployer, modifier et gérer l’intégralité de votre infrastructure Azure de manière professionnelle, reproductible et sécurisée.