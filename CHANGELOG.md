# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-01-16

### Added

- Initial release of Awesome K3s WordPress Helm chart
- WordPress 6.9.0-php8.2-apache support
- MySQL 8.0 StatefulSet with persistent storage
- Automatic Let's Encrypt SSL via cert-manager
- Traefik ingress integration for K3s
- **Optional Redis object cache support** (Redis 7-alpine)
- Configurable values for:
  - Domain and www redirect
  - Let's Encrypt email and server
  - WordPress and MySQL image tags
  - Database credentials
  - Resource limits and requests
  - Persistence storage size
  - Redis enable/disable and configuration
- Health checks for WordPress, MySQL, and Redis
- Init container for MySQL readiness
- Production-ready example values
- Comprehensive documentation

### Security

- Secrets stored as Kubernetes Secrets
- Security contexts for pods
- TLS termination at ingress level
