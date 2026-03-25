# Testing guide for pr-generator Helm Chart

## Prerequisites

```bash
helm repo add devops-ia https://devops-ia.github.io/helm-pr-generator
helm repo update
```

## Configuration testing

### 1. Dry-run with inline secrets (dev/test only)

```bash
helm install pr-generator devops-ia/pr-generator \
  --namespace pr-generator-test \
  --create-namespace \
  --set config.providers.github.owner=my-org \
  --set config.providers.github.repo=my-repo \
  --set config.providers.github.appId=123456 \
  --set config.providers.github.installationId=78901234 \
  --set secrets.github.privateKey="$(cat /path/to/private-key.pem)" \
  --set config.providers.bitbucket.workspace=my-workspace \
  --set config.providers.bitbucket.repoSlug=my-repo \
  --set secrets.bitbucket.token=my-token \
  --dry-run
```

### 2. Using existing Kubernetes Secrets (recommended for production)

```bash
# Create secrets beforehand
kubectl create secret generic pr-generator-github \
  --from-file=private-key.pem=/path/to/private-key.pem \
  -n pr-generator

kubectl create secret generic pr-generator-bitbucket \
  --from-literal=token=my-token \
  -n pr-generator

helm install pr-generator devops-ia/pr-generator \
  --namespace pr-generator \
  --create-namespace \
  --set config.providers.github.owner=my-org \
  --set config.providers.github.repo=my-repo \
  --set config.providers.github.appId=123456 \
  --set config.providers.github.installationId=78901234 \
  --set secrets.github.existingSecret=pr-generator-github \
  --set config.providers.bitbucket.workspace=my-workspace \
  --set config.providers.bitbucket.repoSlug=my-repo \
  --set secrets.bitbucket.existingSecret=pr-generator-bitbucket
```

### 3. Custom scan rules

```bash
helm install pr-generator devops-ia/pr-generator \
  --namespace pr-generator-test \
  --create-namespace \
  --set config.rules[0].pattern="argocd-image-updater-.*-nonpro-.*" \
  --set config.rules[0].destinations.github=develop \
  --set config.rules[0].destinations.bitbucket=nonpro \
  --set config.rules[1].pattern="argocd-image-updater-.*-pro-.*" \
  --set config.rules[1].destinations.github=main \
  --set config.rules[1].destinations.bitbucket=master
```

### 4. Resource configuration testing

```bash
helm install pr-generator devops-ia/pr-generator \
  --namespace pr-generator-test \
  --create-namespace \
  --set resources.limits.memory=512Mi \
  --set resources.requests.cpu=200m \
  --set resources.requests.memory=256Mi
```

## Validation tests

### 1. Pod health check

```bash
kubectl describe pod -l app.kubernetes.io/name=pr-generator -n pr-generator-test
```

### 2. Health endpoint

```bash
kubectl port-forward svc/pr-generator 8080:8080 -n pr-generator-test
curl http://localhost:8080/livez
curl http://localhost:8080/readyz
```

### 3. Config verification

```bash
kubectl exec -it deploy/pr-generator -n pr-generator-test -- cat /etc/pr-generator/config.yaml
```

### 4. Log verification

```bash
kubectl logs -l app.kubernetes.io/name=pr-generator -n pr-generator-test
```

## Template rendering (local)

```bash
helm template pr-generator charts/pr-generator/ \
  --set config.providers.github.owner=my-org \
  --set config.providers.github.repo=my-repo \
  --set config.providers.github.appId=123456 \
  --set config.providers.github.installationId=78901234 \
  --set secrets.github.privateKey=dummy \
  --set config.providers.bitbucket.workspace=my-workspace \
  --set config.providers.bitbucket.repoSlug=my-repo \
  --set secrets.bitbucket.token=dummy
```

## Clean-up

```bash
helm uninstall pr-generator -n pr-generator-test
kubectl delete namespace pr-generator-test
```
