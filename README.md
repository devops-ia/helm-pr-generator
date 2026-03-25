# helm pr-generator

Helm chart for [pr-generator](https://github.com/devops-ia/pr-generator) — automated PR creation from branch patterns detected by Argo CD Image Updater.

## TL;DR

```bash
helm repo add devops-ia https://devops-ia.github.io/helm-pr-generator
helm repo update
helm install pr-generator devops-ia/pr-generator
```

## Introduction

`pr-generator` watches for branches matching configurable regex patterns (e.g. those created by Argo CD Image Updater) and automatically opens Pull Requests against configured destination branches in both **GitHub** (via GitHub App) and **Bitbucket** (via token).

## Prerequisites

- Kubernetes 1.21+
- Helm 3.x
- A GitHub App with `pull_requests: write` and `contents: read` permissions, **or** a GitHub Personal Access Token (PAT) with the same scopes
- A Bitbucket API token with repository write access

## Installing the chart

### GitHub App authentication (default)

```bash
helm install pr-generator devops-ia/pr-generator \
  --namespace pr-generator \
  --create-namespace \
  --set config.providers.github.owner=my-org \
  --set config.providers.github.repo=my-repo \
  --set config.providers.github.appId=123456 \
  --set config.providers.github.installationId=78901234 \
  --set secrets.github.privateKey="$(cat /path/to/private-key.pem)" \
  --set config.providers.bitbucket.workspace=my-workspace \
  --set config.providers.bitbucket.repoSlug=my-repo \
  --set secrets.bitbucket.token=my-token
```

### GitHub PAT authentication

```bash
helm install pr-generator devops-ia/pr-generator \
  --namespace pr-generator \
  --create-namespace \
  --set config.providers.github.authMethod=pat \
  --set config.providers.github.owner=my-org \
  --set config.providers.github.repo=my-repo \
  --set secrets.github.token=ghp_yourtoken \
  --set config.providers.bitbucket.workspace=my-workspace \
  --set config.providers.bitbucket.repoSlug=my-repo \
  --set secrets.bitbucket.token=my-token
```

## Uninstalling the chart

```bash
helm uninstall pr-generator -n pr-generator
```

## Configuration

See [`charts/pr-generator/values.yaml`](charts/pr-generator/values.yaml) for the full list of parameters.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.repository` | Container image repository | `devopsiaci/pr-generator` |
| `image.tag` | Container image tag | `""` (uses `appVersion`) |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `config.scanFrequency` | Scan interval in seconds | `300` |
| `config.logLevel` | Log level (`DEBUG`, `INFO`, `WARNING`, `ERROR`) | `INFO` |
| `config.logFormat` | Log format (`text` or `json` for structured logging) | `text` |
| `config.dryRun` | Dry-run mode (no PRs created) | `false` |
| `config.healthPort` | Health check port | `8080` |
| `config.providers.github.enabled` | Enable GitHub provider | `true` |
| `config.providers.github.authMethod` | Auth method: `app` (GitHub App) or `pat` (Personal Access Token) | `app` |
| `config.providers.github.owner` | GitHub org/user | `""` |
| `config.providers.github.repo` | GitHub repository name | `""` |
| `config.providers.github.appId` | GitHub App ID *(authMethod: app)* | `""` |
| `config.providers.github.installationId` | GitHub App Installation ID *(authMethod: app, auto-resolved if empty)* | `""` |
| `config.providers.github.tokenEnv` | Env var name for PAT token *(authMethod: pat)* | `GITHUB_TOKEN` |
| `config.providers.bitbucket.enabled` | Enable Bitbucket provider | `true` |
| `config.providers.bitbucket.workspace` | Bitbucket workspace | `""` |
| `config.providers.bitbucket.repoSlug` | Bitbucket repo slug | `""` |
| `config.rules` | List of branch pattern → destination rules | see `values.yaml` |
| `secrets.github.existingSecret` | Existing Secret with GitHub credentials | `""` |
| `secrets.github.privateKeyKey` | Key name in Secret for GitHub App PEM *(authMethod: app)* | `private-key.pem` |
| `secrets.github.privateKey` | Inline PEM *(authMethod: app, dev/test only)* | `""` |
| `secrets.github.tokenKey` | Key name in Secret for PAT *(authMethod: pat)* | `token` |
| `secrets.github.token` | Inline PAT *(authMethod: pat, dev/test only)* | `""` |
| `secrets.bitbucket.existingSecret` | Existing Secret with Bitbucket token | `""` |
| `secrets.bitbucket.token` | Inline token (dev/test only) | `""` |

## Using existing Secrets (recommended)

```bash
kubectl create secret generic pr-generator-github \
  --from-file=private-key.pem=/path/to/private-key.pem \
  -n pr-generator

kubectl create secret generic pr-generator-bitbucket \
  --from-literal=token=my-token \
  -n pr-generator

helm install pr-generator devops-ia/pr-generator \
  --set secrets.github.existingSecret=pr-generator-github \
  --set secrets.bitbucket.existingSecret=pr-generator-bitbucket
```

## Testing

See [TESTING.md](TESTING.md) for detailed testing instructions.
