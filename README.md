# API DevOps - Pipeline CI/CD

Trabajo practico de DevOps. Es una API hecha en Flask con un pipeline completo que incluye Docker, Terraform para AWS, Kubernetes, GitHub Actions, monitoreo con Prometheus y Grafana, y algunas configuraciones de FinOps para no gastar de mas.

## Tabla de contenidos

- [Arquitectura](#arquitectura)
- [Tecnologias usadas](#tecnologias-usadas)
- [Estructura del proyecto](#estructura-del-proyecto)
- [Como correrlo localmente](#como-correrlo-localmente)
- [Pipeline CI/CD](#pipeline-cicd)
- [Kubernetes](#kubernetes)
- [Monitoreo](#monitoreo)
- [FinOps](#finops)
- [Evidencias](#evidencias)
- [Validacion](#validacion)
- [Notas y limitaciones](#notas-y-limitaciones)

## Arquitectura

El flujo del pipeline es asi:
Push a GitHub
|
v
GitHub Actions ejecuta:

1.Tests (pytest) + analisis estatico con Bandit

2.Build de Docker + escaneo con Trivy

3.Push de la imagen a Docker Hub

4.Terraform (crea VPC + EKS)

5.kubectl apply de los manifiestos

6.DAST con OWASP ZAP
|
v
Cluster EKS con:

Pods de Flask + Gunicorn

HPA que escala entre 2 y 6 pods

Ingress NGINX

Prometheus + Grafana

Cluster Autoscaler y CronJob para apagar de noche


## Tecnologias usadas

| Categoria | Tecnologia |
|---|---|
| Aplicacion | Python 3.11 + Flask 3.0.3 + Gunicorn |
| Metricas | prometheus-flask-exporter |
| Contenedores | Docker con multi-stage builds |
| IaC | Terraform 1.5+ con modulos de VPC y EKS |
| Orquestacion | Kubernetes (EKS / Docker Desktop) |
| CI/CD | GitHub Actions |
| Seguridad | Bandit (SAST) + Trivy + OWASP ZAP (DAST) |
| Monitoreo | Prometheus + Grafana |
| FinOps | HPA + Cluster Autoscaler + CronJob |

## Estructura del proyecto
Devops-Curso/
├── .github/workflows/
│ └── ci-cd.yml # Pipeline completo
├── app/src/
│ ├── app.py # API Flask
│ ├── test_app.py # Tests con pytest
│ ├── requirements.txt # Dependencias de produccion
│ ├── requirements-dev.txt # Dependencias de desarrollo
│ └── Dockerfile # Multi-stage build
├── terraform/
│ ├── main.tf
│ ├── variables.tf
│ ├── outputs.tf
│ └── modules/
│ ├── vpc/ # VPC, subnets, IGW, NAT
│ └── eks/ # Cluster EKS y node group
├── k8s/
│ ├── deployment.yaml
│ ├── service.yaml
│ ├── ingress.yaml
│ ├── hpa.yaml
│ ├── finops-cronjob.yaml
│ └── finops-rbac.yaml
├── monitoring/
│ ├── docker-compose.monitoring.yml
│ └── prometheus.yml
├── docs/screenshots/ # Capturas de las evidencias
└── README.md

## Como correrlo localmente

Requisitos: Python 3.11+, Docker Desktop con Kubernetes habilitado.

### 1. Levantar la API

```bash
# Crear entorno virtual
python -m venv .venv
source .venv/Scripts/activate     # En Git Bash de Windows
# source .venv/bin/activate       # En Linux o Mac

# Instalar dependencias
pip install -r app/src/requirements.txt
pip install -r app/src/requirements-dev.txt

# Levantar la API en Windows (con Waitress)
cd app/src
waitress-serve --listen=0.0.0.0:5000 app:app