# Project Name

> **📋 TEMPLATE README**: This is an example README.md for your project.
> 1. **Remove this notice** at the top
> 2. **Update sections below** with your project-specific information
> 3. **See [TEMPLATE_README.md](TEMPLATE_README.md)** for complete template documentation and features

---

## Description

Add a brief description of your project here. Explain what it does and why it exists.

## Getting Started

### Prerequisites

- Python 3.12 or higher
- [uv](https://github.com/astral-sh/uv) package manager

### Installation

```bash
# Clone the repository
git clone <your-repository-url>
cd <your-repository-name>

# Run setup script (installs uv, dependencies, and pre-commit hooks)
./scripts/setup.sh
```

### Usage

```bash
# Run via script
./scripts/run_local.sh

# Run the application (update with your actual command)
uv run python src/nbn_dummy_package/hello.py

# Or run as a module
uv run python -m nbn_dummy_package.hello
```

## Development

### Development Scripts

This project includes helper scripts for common development tasks:

```bash
# Setup environment (run once)
./scripts/setup.sh

# Run tests with coverage
./scripts/run_tests.sh

# Run linting and formatting
./scripts/lint.sh

# Run all pre-commit checks
./scripts/run_precommit.sh

# Build the package
./scripts/build.sh

# Try the package locally
./scripts/run_local.sh

# Clean generated files and artifacts
./scripts/clean.sh          # Keep .venv/
./scripts/clean.sh --all    # Remove .venv/ too
```

### Common Development Commands

Add your project-specific commands here.

## CI/CD

This project uses GitHub Actions for automated testing and releases.

### Continuous Integration
- Automated testing on all PRs and pushes to `master`
- Pre-commit checks (linting, formatting)
- Test coverage enforcement (80% for new code)
- Multi-Python version testing (3.12, 3.13)

### Releases

Create a release PR via GitHub Actions:
1. Go to Actions → `2. Create Release PR [manual]`
2. Click "Run workflow"
3. Choose version bump (`patch`/`minor`/`major`) or enter a custom version

What this workflow does:
- Calculates the next version (or uses the custom input)
- Updates the changelog using Commitizen (`cz changelog`)
- Bumps the project version using Commitizen (`cz bump`)
- Creates a branch `release/v<version>` and opens a PR to `master`

After the PR is approved and merged, follow your release/publish process (e.g., tagging and artifact publishing) as per your organization standards or a separate workflow if configured.

## Contributing

See [TEMPLATE_README.md](TEMPLATE_README.md) for:
- Commit message conventions (Conventional Commits required)
- Testing guidelines
- Code style guidelines
- Pre-commit hook details

## License

Proprietary - Internal NBN use only. See [LICENSE](LICENSE) for details.
