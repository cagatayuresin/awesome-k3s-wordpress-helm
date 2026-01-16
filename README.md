# Awesome K3s WordPress Helm

[![Awesome](https://awesome.re/badge.svg)](https://awesome.re)
[![Helm](https://img.shields.io/badge/Helm-v3-blue?logo=helm)](https://helm.sh)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-K3s-326CE5?logo=kubernetes)](https://k3s.io)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![WordPress](https://img.shields.io/badge/WordPress-6.9.0-21759B?logo=wordpress)](https://wordpress.org)

A production-ready WordPress Helm chart optimized for K3s with automatic Let's Encrypt SSL support via cert-manager.

## ✨ Features

- 🔐 **Automatic SSL** - Let's Encrypt certificates via cert-manager
- 💾 **Persistent Storage** - Data survives pod restarts using local-path
- ⚙️ **Fully Configurable** - Domain, secrets, and image tags via values.yaml
- 🏭 **Production Ready** - Resource limits, health checks, and security contexts
- 🚀 **K3s Optimized** - Uses Traefik ingress and local-path storage class
- 📦 **Single Command Deploy** - Get WordPress running in minutes

## 📋 Prerequisites

1. **K3s cluster** with Traefik ingress controller (included by default)
2. **cert-manager** installed for SSL certificates:
   ```bash
   kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.4/cert-manager.yaml
   ```
3. **Helm 3.x** installed
4. **DNS configured** - Your domain's A record pointing to your k3s node's public IP

## 🚀 Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/cagatayuresin/awesome-k3s-wordpress-helm.git
cd awesome-k3s-wordpress-helm
```

### 2. Create your custom values file

```bash
cp wordpress-helm/values.yaml my-values.yaml
```

### 3. Edit your values

```yaml
# my-values.yaml
domain: yourdomain.com

letsencrypt:
  email: your-email@yourdomain.com

mysql:
  rootPassword: "your-secure-root-password"
  password: "your-secure-wordpress-password"

wordpress:
  image:
    tag: 6.9.0-php8.2-apache
```

### 4. Install the chart

```bash
helm install my-wordpress wordpress-helm/ -f my-values.yaml
```

## ⚙️ Configuration

### Essential Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `domain` | Your domain name | `example.com` |
| `letsencrypt.email` | Email for Let's Encrypt | `admin@example.com` |
| `wordpress.image.tag` | WordPress image tag | `6.9.0-php8.2-apache` |
| `mysql.rootPassword` | MySQL root password | `changeme-root-password` |
| `mysql.password` | WordPress DB password | `changeme-wordpress-password` |

### Full Configuration Reference

<details>
<summary>Click to expand all parameters</summary>

#### Namespace
| Parameter | Description | Default |
|-----------|-------------|---------|
| `namespace` | Kubernetes namespace | `wordpress` |
| `createNamespace` | Create namespace | `true` |

#### Domain & SSL
| Parameter | Description | Default |
|-----------|-------------|---------|
| `domain` | Your domain | `example.com` |
| `enableWwwRedirect` | Handle www subdomain | `true` |
| `letsencrypt.email` | Certificate email | `admin@example.com` |
| `letsencrypt.server` | ACME server URL | production |
| `letsencrypt.createClusterIssuer` | Create ClusterIssuer | `true` |
| `letsencrypt.clusterIssuerName` | ClusterIssuer name | `letsencrypt-prod` |

#### WordPress
| Parameter | Description | Default |
|-----------|-------------|---------|
| `wordpress.image.repository` | Image repository | `wordpress` |
| `wordpress.image.tag` | Image tag | `6.9.0-php8.2-apache` |
| `wordpress.replicas` | Number of replicas | `1` |
| `wordpress.tablePrefix` | Database table prefix | `wp_` |
| `wordpress.debug` | Enable WP_DEBUG | `false` |
| `wordpress.resources.requests.memory` | Memory request | `256Mi` |
| `wordpress.resources.requests.cpu` | CPU request | `250m` |
| `wordpress.resources.limits.memory` | Memory limit | `512Mi` |
| `wordpress.resources.limits.cpu` | CPU limit | `500m` |

#### MySQL
| Parameter | Description | Default |
|-----------|-------------|---------|
| `mysql.image.repository` | Image repository | `mysql` |
| `mysql.image.tag` | Image tag | `8.0` |
| `mysql.rootPassword` | Root password | `changeme-root-password` |
| `mysql.database` | Database name | `wordpress` |
| `mysql.user` | WordPress user | `wordpress` |
| `mysql.password` | WordPress password | `changeme-wordpress-password` |
| `mysql.characterSet` | Character set | `utf8mb4` |
| `mysql.collation` | Collation | `utf8mb4_unicode_ci` |

#### Persistence
| Parameter | Description | Default |
|-----------|-------------|---------|
| `persistence.storageClass` | Storage class | `local-path` |
| `persistence.wordpress.enabled` | Enable WP persistence | `true` |
| `persistence.wordpress.size` | WP PVC size | `10Gi` |
| `persistence.mysql.enabled` | Enable MySQL persistence | `true` |
| `persistence.mysql.size` | MySQL PVC size | `10Gi` |

</details>

## 📖 Usage

### Install

```bash
helm install my-wordpress wordpress-helm/ -f my-values.yaml
```

### Upgrade

```bash
helm upgrade my-wordpress wordpress-helm/ -f my-values.yaml
```

### Uninstall

```bash
helm uninstall my-wordpress
```

> ⚠️ **Note**: PersistentVolumeClaims are not deleted automatically. To delete all data:
> ```bash
> kubectl delete pvc -l app.kubernetes.io/instance=my-wordpress -n wordpress
> ```

## ✅ Verify Installation

### Check pod status

```bash
kubectl get pods -n wordpress
```

### Check certificate status

```bash
kubectl get certificate -n wordpress
```

### View WordPress logs

```bash
kubectl logs -f deployment/my-wordpress-wordpress -n wordpress
```

## 🔧 Troubleshooting

<details>
<summary>Certificate not issuing</summary>

1. Check ClusterIssuer status:
   ```bash
   kubectl describe clusterissuer letsencrypt-prod
   ```

2. Check certificate request:
   ```bash
   kubectl describe certificaterequest -n wordpress
   ```

3. Check cert-manager logs:
   ```bash
   kubectl logs -n cert-manager -l app=cert-manager
   ```
</details>

<details>
<summary>Pods not starting</summary>

1. Describe the pod:
   ```bash
   kubectl describe pod -l app.kubernetes.io/instance=my-wordpress -n wordpress
   ```

2. Check events:
   ```bash
   kubectl get events -n wordpress --sort-by='.lastTimestamp'
   ```
</details>

<details>
<summary>Database connection issues</summary>

1. Verify MySQL is running:
   ```bash
   kubectl get pods -l app.kubernetes.io/component=mysql -n wordpress
   ```

2. Check MySQL logs:
   ```bash
   kubectl logs statefulset/my-wordpress-mysql -n wordpress
   ```
</details>

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                           Internet                               │
└─────────────────────────────────┬───────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Traefik Ingress (K3s)                        │
│                    + Let's Encrypt TLS                          │
└─────────────────────────────────┬───────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────┐
│                      WordPress Deployment                        │
│                    (wordpress:6.9.0-php8.2-apache)              │
│                                                                  │
│  ┌─────────────────┐        ┌─────────────────────────────────┐ │
│  │  WordPress Pod  │───────▶│  PVC: wordpress-data (10Gi)     │ │
│  └────────┬────────┘        └─────────────────────────────────┘ │
└───────────┼─────────────────────────────────────────────────────┘
            │
            ▼
┌─────────────────────────────────────────────────────────────────┐
│                      MySQL StatefulSet                           │
│                         (mysql:8.0)                              │
│                                                                  │
│  ┌─────────────────┐        ┌─────────────────────────────────┐ │
│  │   MySQL Pod     │───────▶│  PVC: mysql-data (10Gi)         │ │
│  └─────────────────┘        └─────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⭐ Show Your Support

If this project helped you, please give it a ⭐ on GitHub!

## 📬 Contact

- GitHub: [@cagatayuresin](https://github.com/cagatayuresin)

---

Made with ❤️ for the K3s community
