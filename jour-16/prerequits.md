
# Comprendre OCI et ORAS simplement

## 1. OCI (Open Container Initiative)

Open Container Initiative

OCI est une organisation créée pour définir des **standards ouverts** autour des conteneurs.

En gros :

> OCI définit COMMENT les images de conteneurs doivent être construites, stockées et exécutées.

---

# Pourquoi OCI existe ?

Avant :

* Docker avait son propre format
* Chaque plateforme faisait un peu ce qu’elle voulait

Problème :

* incompatibilités
* vendor lock-in
* difficulté d’interopérabilité

Donc OCI a créé des standards universels.

---

# Les 3 standards OCI les plus importants

## A. OCI Image Spec

Définit :

* la structure d’une image container

Exemple :

```bash
nginx:latest
```

Une image OCI contient :

* layers
* metadata
* manifest
* config

---

## B. OCI Runtime Spec

Définit :

* comment exécuter un conteneur

Exemple de runtime :

* runc
* crun

Quand Docker lance un container :

```bash
docker run nginx
```

à la fin :
→ un runtime OCI exécute réellement le process.

---

## C. OCI Distribution Spec

Définit :

* comment pousser/puller les artefacts depuis un registry.

Exemple :

```bash
docker push
docker pull
```

Compatible avec :

* Docker Hub
* GitHub Container Registry
* Google Artifact Registry
* Amazon ECR
* Microsoft ACR
* Oracle OCI Registry

---

# Architecture simplifiée OCI

```text
Docker Build
      ↓
Image OCI
      ↓
Registry OCI
      ↓
Runtime OCI
      ↓
Container Running
```

---

# Maintenant ORAS

## 2. ORAS (OCI Registry As Storage)

ORAS Project

ORAS est un outil qui permet de stocker **n’importe quel fichier** dans un registry OCI.

---

# Le problème avant ORAS

Les registries stockaient surtout :

* images Docker
* images containers

Mais dans le monde DevOps moderne on veut aussi stocker :

* modèles IA
* Helm charts
* fichiers ZIP
* SBOM
* signatures
* WASM
* binaires
* manifests Kubernetes
* artefacts ML

---

# ORAS dit :

> “Un registry OCI peut stocker bien plus que des images Docker.”

Donc :

* un registry devient un stockage universel d’artefacts.

---

# Exemple concret

Tu peux pousser un fichier ZIP :

```bash
oras push ghcr.io/donald/app:v1 app.zip
```

Puis le récupérer :

```bash
oras pull ghcr.io/donald/app:v1
```

---

# Ce que ORAS stocke réellement

ORAS transforme les fichiers en :

* layers OCI
* manifests OCI

Donc :
✅ compatible avec le standard OCI.

---

# Exemple réel d’utilisation

## Sans ORAS

Tu stockes :

* ton modèle IA sur S3
* ton SBOM ailleurs
* tes signatures ailleurs

→ chaos.

---

## Avec ORAS

Tout est stocké dans :

* un registry OCI centralisé.

Exemple :

```text
registry.company.com
 ├── app-image
 ├── ai-model
 ├── sbom
 ├── signatures
 ├── helm-chart
 └── policies
```

---

# Pourquoi ORAS devient très important

Avec :

* Kubernetes
* GitOps
* AI/ML
* Supply Chain Security
* DevSecOps

les registries OCI deviennent :

> le centre de stockage universel du cloud natif.

---

# Exemple DevOps moderne

Pipeline CI/CD :

```text
Code Source
    ↓
Build Docker Image
    ↓
Generate SBOM
    ↓
Sign Artifact
    ↓
Push everything to OCI Registry
```

Avec :

* Docker/BuildKit
* Cosign
* ORAS
* OCI Registry

---

# Technologies liées à ORAS

## Helm

Les charts Helm peuvent être stockés dans OCI :

```bash
helm push mychart oci://registry.io/charts
```

---

## Cosign

Sigstore Cosign utilise OCI pour :

* signatures
* attestations

---

## Kubernetes

K8s utilise énormément l’écosystème OCI.

---

# Différence simple OCI vs ORAS

| OCI                 | ORAS               |
| ------------------- | ------------------ |
| Standard            | Outil              |
| Définit les règles  | Utilise les règles |
| Spécification       | Implémentation     |
| Format universel    | Stockage universel |
| Base des containers | Base des artefacts |

---

# Analogie simple

## OCI

Comme :

> les règles officielles des conteneurs.

---

## ORAS

Comme :

> un camion qui utilise ces règles pour transporter n’importe quel objet.

---

# Exemple ultra concret

## Docker classique

```bash
docker push nginx
```

→ pousse une image container.

---

## ORAS

```bash
oras push registry/app docs.pdf
```

→ pousse un PDF dans un registry OCI.

---

Comprendre OCI + ORAS est extrêmement utile pour :

* Kubernetes avancé
* supply chain security
* AI artifact management
* plateformes SaaS modernes
* MLOps
* Internal Developer Platforms

---

# À retenir

## OCI

= standard universel des conteneurs et artefacts cloud natifs.

## ORAS

= outil permettant d’utiliser les registries OCI comme stockage universel d’artefacts.

---

# Technologies à apprendre ensuite

Je te conseille ensuite :

1. Docker image internals
2. containerd
3. runc
4. BuildKit
5. Helm OCI
6. Cosign
7. Harbor Registry
8. Artifact Registry
9. Supply Chain Security
10. SBOM & SLSA

Ce sont les technos utilisées aujourd’hui dans les architectures cloud très avancées.
