# Copilot Instructions

## Repository overview

This is a Helm chart repository for [pr-generator](https://github.com/devops-ia/pr-generator) — a tool that watches for branches matching configurable regex patterns (e.g. those created by Argo CD Image Updater) and automatically opens Pull Requests against configured destination branches in GitHub and/or Bitbucket.

The chart lives at `charts/pr-generator/`. There is no application source code here.

## Commands

### Local template rendering (primary dev workflow)
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

### Helm dry-run (validates against a cluster)
```bash
helm install pr-generator charts/pr-generator/ --dry-run --namespace pr-generator-test --create-namespace [--set ...]
```

### Lint
```bash
helm lint charts/pr-generator/
```

### Pre-commit (runs helmlint, helm-docs, trailing-whitespace, markdown-toc)
```bash
pre-commit run --all-files
```

## Architecture

### Config rendering pipeline
`values.yaml` uses **camelCase** keys. The `configmap.yaml` template maps these to **snake_case** when rendering the application's `/etc/pr-generator/config.yaml`. For example, `config.scanFrequency` → `scan_frequency`, `config.providers.github.authMethod` → `auth_method`. Keep this mapping in mind when adding new config fields.

### Multi-provider support
The chart supports multiple named provider instances of the same type (e.g. two GitHub orgs). Each key under `config.providers` is a free-form name used in `rules[].destinations`. The keys `github` and `bitbucket` auto-infer their type; all other names require `type: github` or `type: bitbucket`.

### Secret model — one global Secret per provider type
- `secrets.github.existingSecret`: one Secret shared by all GitHub providers. Each provider's `privateKeyKey` / `tokenKey` selects which key inside that Secret holds its credential.
- `secrets.bitbucket.existingSecret`: same pattern for Bitbucket providers.
- **Inline** (`secrets.github.privateKey` / `secrets.github.token` / `secrets.bitbucket.token`): chart creates `<fullname>-github-secrets` and/or `<fullname>-bitbucket-secrets`. Only supports a single credential per type — for multi-provider setups with different credentials, always use `existingSecret`.

`secret.yaml` only renders when inline values are provided and no `existingSecret` is set.

### GitHub auth — two modes
- **`authMethod: app`** (default): PEM is mounted from the GitHub Secret at `/secrets/github/<privateKeyKey>`. The volume mounts the whole GitHub Secret with explicit `items` (one per distinct `privateKeyKey` across all App providers). The `private_key_path` in `config.yaml` points to `/secrets/github/<privateKeyKey>`.
- **`authMethod: pat`**: token is injected as an env var named by `tokenEnv`, sourced from the GitHub Secret key `tokenKey`.

Bitbucket always uses a token env var sourced from the Bitbucket Secret key `tokenKey`.

### Replica constraint
The deployment is hardcoded to `replicas: 1`. Do **not** change this. The application uses in-memory per-cycle caches with no distributed coordination; multiple replicas cause duplicate PR creation. See the comment in `deployment.yaml`.

### Automatic rollout on config change
`deployment.yaml` includes a `checksum/config` pod annotation computed from the rendered ConfigMap. This triggers a rolling restart whenever `config.*` values change — no manual rollout needed.

### Schema validation
`values.schema.json` enforces the values. Notably: `config.rules` requires `minItems: 1` — the chart will not install without at least one rule defined.

## Key conventions

- **Chart version** (`Chart.yaml`) must be bumped on every change to `charts/pr-generator/`. CI releases are triggered by pushes to `main` when chart files change.
- **`helm-docs`** is run via pre-commit. Keep `values.yaml` comments in sync with what `helm-docs` would generate.
- **`extra-manifests.yaml`** renders `extraObjects` — use this to deploy any additional Kubernetes resources alongside the chart without modifying core templates.
- **CI** uses reusable workflows from `devops-ia/.github`. Chart testing (`ct`) is configured in `.github/ct.yaml`; chart releasing (`cr`) in `.github/cr.yaml`.
