# Trivy Security Scanning Guide

Trivy is a comprehensive vulnerability scanner for Docker images and filesystems. This guide explains how to use Trivy with the voting app.

## Quick Start

### Option 1: Scan Images (Recommended for CI/CD)

```bash
# Scan a specific image
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image voting-app_vote:latest

# Scan with severity filter
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image --severity HIGH,CRITICAL voting-app_vote:latest
```

### Option 2: Scan Filesystem

```bash
# Scan current directory
docker run --rm -v ${PWD}:/root \
  aquasec/trivy fs /root

# Scan with severity filter
docker run --rm -v ${PWD}:/root \
  aquasec/trivy fs --severity HIGH,CRITICAL /root
```

### Option 3: Using Compose Override

```bash
# Run entire stack with Trivy scanner
docker-compose -f docker-compose.yml -f docker-compose.trivy.yml up --profile scan
```

### Option 4: Run Batch Scan Script

```bash
chmod +x trivy-scan.sh
./trivy-scan.sh
```

## Severity Levels

- **CRITICAL**: Most urgent, requires immediate action
- **HIGH**: Important vulnerabilities, should be addressed
- **MEDIUM**: Moderate risk, consider fixing
- **LOW**: Minor issues, can usually wait

## Ignoring Vulnerabilities

Add CVE IDs to `.trivyignore` file to skip specific vulnerabilities:

```
# Example .trivyignore
CVE-2024-1234
CVE-2024-5678
```

## Output Formats

Generate reports in different formats:

```bash
# JSON output
docker run --rm -v ${PWD}:/root \
  aquasec/trivy fs --format json --output /root/trivy-report.json /root

# SARIF format (for GitHub integration)
docker run --rm -v ${PWD}:/root \
  aquasec/trivy fs --format sarif --output /root/trivy-report.sarif /root

# Table format (human-readable)
docker run --rm -v ${PWD}:/root \
  aquasec/trivy fs --format table /root
```

## Integration with CI/CD

Add to your pipeline to fail on vulnerabilities:

```bash
docker run --rm -v ${PWD}:/root \
  aquasec/trivy fs --exit-code 1 --severity HIGH,CRITICAL /root
```

This will exit with code 1 if vulnerabilities are found.

## Useful Links

- [Trivy Documentation](https://aquasecurity.github.io/trivy/)
- [GitHub Repository](https://github.com/aquasecurity/trivy)
- [Docker Hub Image](https://hub.docker.com/r/aquasec/trivy)
