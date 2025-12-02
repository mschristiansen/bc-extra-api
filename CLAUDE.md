# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Per-Tenant Extension (PTE) template for Microsoft Dynamics 365 Business Central using the AL programming language. The project uses AL-Go v8.0 for GitHub Actions-based CI/CD.

## Development Environment Setup

Local development uses Docker-based Business Central containers or cloud sandboxes:

```powershell
# Create local Docker-based dev environment (interactive)
.\.AL-Go\localDevEnv.ps1

# Create cloud-based Business Central Sandbox (interactive)
.\.AL-Go\cloudDevEnv.ps1
```

These scripts download helpers from the AL-Go-Actions repository and should not be modified directly. Create a wrapper script (e.g., `my-devenv.ps1`) for custom parameters.

## Build and CI/CD

All build, test, and deployment operations run through GitHub Actions workflows:

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| `CICD.yaml` | Push to main/release/feature branches | Main CI/CD pipeline |
| `PullRequestHandler.yaml` | Pull requests | PR validation |
| `CreateApp.yaml` | Manual dispatch | Scaffold new AL app |
| `CreateTestApp.yaml` | Manual dispatch | Scaffold test app |
| `CreateRelease.yaml` | Manual dispatch | Create versioned release |
| `PublishToEnvironment.yaml` | Manual dispatch | Deploy to BC environment |

There are no local CLI build commands - all builds happen in GitHub Actions using `microsoft/AL-Go-Actions@v8.0`.

## Project Structure

```
.AL-Go/
  settings.json          # Project settings (appFolders, testFolders, country)
  localDevEnv.ps1        # Local dev environment script
  cloudDevEnv.ps1        # Cloud dev environment script

.github/
  AL-Go-Settings.json    # Repository settings (type: PTE)
  workflows/             # GitHub Actions workflows
  Test*.settings.json    # Version-specific test configurations
```

Apps are created via the CreateApp workflow and placed in directories like `app<Name>/`. Test apps go in `test<Name>/`. Build artifacts (.app files) are gitignored.

## Configuration Hierarchy

Settings cascade: organization → repository → project → environment. Key files:
- `.github/AL-Go-Settings.json` - Repository-level (template type)
- `.AL-Go/settings.json` - Project-level (app folders, country code)
- `.github/Test*.settings.json` - Environment-specific test settings

Settings schema: https://aka.ms/algosettings

## Branch Conventions

- `main` - Production branch
- `release/*` - Release branches
- `feature/*` - Feature branches

All branches trigger the CICD workflow on push.
