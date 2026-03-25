# pr-generator

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v1.0.0](https://img.shields.io/badge/AppVersion-v1.0.0-informational?style=flat-square)

Helm chart for pr-generator — automated PR creation from branch patterns

**Homepage:** <https://github.com/devops-ia/helm-pr-generator>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| amartingarcia | <adrianmg231189@gmail.com> |  |

## Source Code

* <https://github.com/devops-ia/pr-generator>
* <https://github.com/devops-ia/helm-pr-generator>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| annotations | object | `{}` |  |
| config.dryRun | bool | `false` |  |
| config.healthPort | int | `8080` |  |
| config.logFormat | string | `"text"` |  |
| config.logLevel | string | `"INFO"` |  |
| config.providers.bitbucket-org1.closeSourceBranch | bool | `true` |  |
| config.providers.bitbucket-org1.enabled | bool | `false` |  |
| config.providers.bitbucket-org1.repoSlug | string | `""` |  |
| config.providers.bitbucket-org1.timeout | int | `30` |  |
| config.providers.bitbucket-org1.tokenEnv | string | `"BITBUCKET_TOKEN"` |  |
| config.providers.bitbucket-org1.tokenKey | string | `"token"` |  |
| config.providers.bitbucket-org1.workspace | string | `""` |  |
| config.providers.bitbucket.closeSourceBranch | bool | `true` |  |
| config.providers.bitbucket.enabled | bool | `false` |  |
| config.providers.bitbucket.repoSlug | string | `""` |  |
| config.providers.bitbucket.timeout | int | `30` |  |
| config.providers.bitbucket.tokenEnv | string | `"BITBUCKET_TOKEN"` |  |
| config.providers.bitbucket.tokenKey | string | `"token"` |  |
| config.providers.bitbucket.workspace | string | `""` |  |
| config.providers.github.appId | string | `""` |  |
| config.providers.github.authMethod | string | `"app"` |  |
| config.providers.github.enabled | bool | `false` |  |
| config.providers.github.installationId | string | `""` |  |
| config.providers.github.owner | string | `""` |  |
| config.providers.github.privateKeyKey | string | `"private-key.pem"` |  |
| config.providers.github.repo | string | `""` |  |
| config.providers.github.timeout | int | `30` |  |
| config.providers.github.tokenEnv | string | `"GITHUB_TOKEN"` |  |
| config.providers.github.tokenKey | string | `"token"` |  |
| config.rules[0].destinations.bitbucket | string | `"dev"` |  |
| config.rules[0].destinations.bitbucket-org1 | string | `"dev"` |  |
| config.rules[0].destinations.github | string | `"develop"` |  |
| config.rules[0].pattern | string | `"argocd-image-updater-.*-dev-.*"` |  |
| config.rules[1].destinations.bitbucket | string | `"master"` |  |
| config.rules[1].destinations.github | string | `"main"` |  |
| config.rules[1].pattern | string | `"argocd-image-updater-.*-pro-.*"` |  |
| config.scanFrequency | int | `300` |  |
| env | list | `[]` |  |
| envFrom | list | `[]` |  |
| extraObjects | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"devopsiaci/pr-generator"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| livenessProbe.failureThreshold | int | `3` |  |
| livenessProbe.httpGet.path | string | `"/livez"` |  |
| livenessProbe.httpGet.port | string | `"health"` |  |
| livenessProbe.initialDelaySeconds | int | `5` |  |
| livenessProbe.periodSeconds | int | `10` |  |
| livenessProbe.successThreshold | int | `1` |  |
| livenessProbe.timeoutSeconds | int | `2` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| readinessProbe.failureThreshold | int | `3` |  |
| readinessProbe.httpGet.path | string | `"/readyz"` |  |
| readinessProbe.httpGet.port | string | `"health"` |  |
| readinessProbe.initialDelaySeconds | int | `10` |  |
| readinessProbe.periodSeconds | int | `10` |  |
| readinessProbe.successThreshold | int | `1` |  |
| readinessProbe.timeoutSeconds | int | `2` |  |
| resources.limits.memory | string | `"256Mi"` |  |
| resources.requests.cpu | string | `"100m"` |  |
| resources.requests.memory | string | `"128Mi"` |  |
| secrets.bitbucket.existingSecret | string | `""` |  |
| secrets.bitbucket.token | string | `""` |  |
| secrets.github.existingSecret | string | `""` |  |
| secrets.github.privateKey | string | `""` |  |
| secrets.github.token | string | `""` |  |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `1000` |  |
| tolerations | list | `[]` |  |
| topologySpreadConstraints | list | `[]` |  |
| volumeMounts | list | `[]` |  |
| volumes | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
