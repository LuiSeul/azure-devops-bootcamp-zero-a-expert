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