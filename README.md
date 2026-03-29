# Sonar Scanner — GitHub Actions Workflow

A reusable GitHub Actions workflow that automatically runs a [SonarQube](https://www.sonarqube.org/) static code analysis scan on every push or pull request to `main`. The runtime (language) is resolved dynamically from a `requirements.txt` config file, so the same workflow supports multiple tech stacks without any changes to the YAML.

## How It Works

```
push / pull_request to main
        │
        ▼
┌─────────────────────┐
│  runtime_resolution │  ← reads runtime= from requirements.txt
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│   clone_and_scan    │  ← runs the matching Sonar scan step
└─────────────────────┘
```

The workflow has two jobs:

| Job | What it does |
|---|---|
| `runtime_resolution` | Reads the `runtime` key from `requirements.txt`, validates it, and passes it downstream |
| `clone_and_scan` | Reads repo config, sets the runtime, and conditionally runs the matching scan |

## Supported Runtimes

| `runtime=` value | Scan method | File inclusions |
|---|---|---|
| `python` | `sonarqube-scan-action@v5.2.0` | `**/*.py` |
| `node` | `sonarqube-scan-action@v5.2.0` | `**/*.js, **/*.jsx, **/*.ts, **/*.tsx` |
| `java` | Maven (`sonar-maven-plugin 4.0.0`) | `**/*.java` |
| `flutter` | `sonarqube-scan-action@v5.2.0` | `**/*.dart` |
| `dart` | `sonarqube-scan-action@v5.2.0` | `**/*.dart` |
| `go` | `sonarqube-scan-action@v5.2.0` | *(default sources)* |
| *(empty / invalid)* | `sonarqube-scan-action@v5.2.0` | *(default sources)* |

> If an unrecognised runtime is supplied, the workflow falls back to a default scan instead of failing.

## Setup

### 1. Add GitHub Secrets

Go to **Settings → Secrets and variables → Actions** and add:

| Secret | Description |
|---|---|
| `SONAR_TOKEN` | Authentication token from your SonarQube / SonarCloud account |
| `SONAR_HOST_URL` | Your SonarQube server URL (e.g. `https://sonarcloud.io`) |

### 2. Create a `requirements.txt` in your repo root

```
runtime=python
repo_url=https://github.com/your-org/your-repo
repo_name=your-repo
branch_name=main
source_directory=src
```

> All fields are read with `grep '^key'` so order does not matter. If `runtime` is omitted or invalid, the workflow falls back to a default scan.

### 3. Add the workflow file

Place `sonar.yml` in `.github/workflows/` in your repository.

```
.github/
└── workflows/
    └── sonar.yml
requirements.txt
```

## Triggers

The workflow runs on:

- **Push** to `main`
- **Pull request** targeting `main`

## `requirements.txt` Reference

| Key | Required | Description |
|---|---|---|
| `runtime` | No | Language runtime — see supported values above |
| `repo_url` | Yes | Full URL of the repository to scan |
| `repo_name` | Yes | Short name of the repository |
| `branch_name` | Yes | Branch to scan |
| `source_directory` | No | Source root directory |

