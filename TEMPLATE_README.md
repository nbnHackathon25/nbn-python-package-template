# NBN Python Template

A modern Python project template for NBN Co repositories, following Python best practices and including essential development tools.

## Table of Contents

- [Quick Start](#quick-start-for-template-users)
- [Overview](#overview)
- [Features](#features)
- [Project Structure](#project-structure)
- [Installation & Setup](#installation--setup)
- [Development](#development)
- [Testing](#testing-guidelines)
- [CI/CD Pipeline](#continuous-integration--deployment)
- [Contributing](#contributing)
- [Resources](#resources)

---

## Quick Start for Template Users

### 1. Use This Template
Click "Use this template" button on GitHub or clone this repository.

### 2. Customize Your Project
- Update `pyproject.toml`: package name, version, authors, description
- Rename `src/nbn_dummy_package/` to your package name
- Update imports in `tests` to match new package name
- Replace `README.md` with your project-specific documentation
- Update `.github/CODEOWNERS` with your team
- Configure `JFROG_TOKEN` secret in repository settings (for releases)

### 3. Set Up Development Environment
```bash
# Install dependencies
uv sync --all-groups

# Install pre-commit hooks
uv run pre-commit install --hook-type pre-commit --hook-type pre-push --hook-type commit-msg

# Verify setup
uv run pre-commit run --all-files
```

### 4. Start Developing
You're ready to go! See the sections below for detailed documentation on all features.

---

## Overview

This template provides a solid foundation for Python projects with:
- Modern dependency management using [uv](https://github.com/astral-sh/uv)
- Code quality tools: [ruff](https://github.com/astral-sh/ruff) for linting and formatting
- Pre-commit hooks for automated code quality checks
- Unit testing with [pytest](https://pytest.org/) and coverage reporting
- Proper project structure following Python packaging best practices
- CI/CD pipeline using GitHub Actions for automated testing, coverage enforcement, and releases

## Features

- ✅ **Modern Dependency Management**: Uses `uv` for fast, reliable dependency resolution
- ✅ **Code Quality**: Integrated `ruff` for linting and formatting
- ✅ **Pre-commit Hooks**: Automated code quality checks and testing before commits
- ✅ **Testing Framework**: Complete test setup with `pytest` and `pytest-cov`
- ✅ **Coverage Enforcement**: New line coverage validation (diff-cover) in CI
- ✅ **Type Hints**: Encouraged use of Python type hints
- ✅ **Documentation**: Well-documented code with docstrings
- ✅ **Project Structure**: Follows src-layout for better package organization

## Project Structure

```
.
├── .github/
│   ├── workflows/
│   │   ├── ci.yml
│   │   ├── release-branch.yml
│   │   └── release-publish.yml
│   ├── instructions/
│   ├── agents/
│   ├── CODEOWNERS
│   └── pull_request_template.md
├── src/
│   └── nbn_dummy_package/
│       ├── __init__.py
│       └── hello.py
├── tests/
│   ├── __init__.py
│   └── test_hello.py
├── .pre-commit-config.yaml
├── .python-version
├── .vscode/
│   └── settings.json
├── CODE_OF_CONDUCT.md
├── LICENSE
├── pyproject.toml
└── README.md
```

## Requirements

- Python 3.12 or higher
- [uv](https://github.com/astral-sh/uv) package manager

---

## Installation & Setup

### 1. Install uv (if not already installed)

```bash
# Using pip
python3 -m pip install uv

# Or using the standalone installer (Linux/macOS)
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### 2. Clone the Repository

```bash
git clone <repository-url>
cd nbn-python-repo-template
```

### 3. Install Dependencies

```bash
# Install all dependencies including dev dependencies
uv sync --all-groups

# Create and activate the virtual environment
uv venv
source .venv/bin/activate  # On Linux/macOS
# or
.venv\Scripts\activate     # On Windows
```

### 4. Install Pre-commit Hooks

```bash
# Install pre-commit hooks for both commit and push stages
uv run pre-commit install --hook-type pre-commit --hook-type commit-msg --hook-type pre-push

# (Optional) Run against all files to verify setup
uv run pre-commit run --all-files
```

**Pre-commit Hooks Included:**

*On every commit (`pre-commit` stage):*
- Code formatting with Ruff
- Code linting with Ruff (auto-fix enabled)
- Code quality checks (trailing whitespace, YAML/JSON/TOML validation, etc.)
- Merge conflict detection
- Debug statement detection

*On commit message (`commit-msg` stage):*
- Conventional commit message validation
- Dependency locking (`uv.lock` stays up to date)

*On every push (`pre-push` stage):*
- Test execution with coverage (generates coverage.xml)
- Diff-cover validation (ensures 80% coverage on changed lines)
- Branch name validation (commitizen)

Hooks run automatically at their respective stages, catching issues early while keeping commits fast.

---

## Development

### Commit Message Convention

This project enforces [Conventional Commits](https://www.conventionalcommits.org/) to maintain a clear and consistent commit history. All commit messages are automatically validated using [commitizen](https://commitizen-tools.github.io/commitizen/).

#### Commit Message Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

#### Common Types

- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that don't affect code meaning (whitespace, formatting, etc.)
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `build`: Changes to build system or dependencies
- `ci`: Changes to CI configuration files and scripts
- `chore`: Other changes that don't modify src or test files

#### Examples

```bash
fix: resolve memory leak in data processing
feat(auth): add user authentication module
docs: update installation instructions
ci: add conventional commit validation
```

#### Using Commitizen CLI

For an interactive commit experience:

```bash
# Use commitizen to create a commit
uv run cz commit

# Or use the shortcut
uv run cz c
```

The commitizen CLI will prompt you for type, scope, description, and breaking changes.


### Code Quality Checks

#### Linting with Ruff

```bash
# Check code for issues
uv run ruff check

# Auto-fix issues where possible
uv run ruff check --fix

# Check specific files
uv run ruff check src/nbn_dummy_package/
```

#### Formatting with Ruff

```bash
# Check formatting
uv run ruff format --check

# Apply formatting
uv run ruff format
```

#### Run Pre-commit Hooks Manually

```bash
# Run all hooks on all files
uv run pre-commit run --all-files

# Run specific hook only
uv run pre-commit run trailing-whitespace --all-files
```

### Adding New Dependencies

```bash
# Add a runtime dependency
uv add package-name

# Add a development dependency
uv add --dev package-name

# Remove a dependency
uv remove package-name
```

### Code Style Guidelines

This project follows [PEP 8](https://pep8.org/) style guidelines, enforced by `ruff`:

- Line length: 120 characters
- Indentation: 4 spaces
- Quote style: Double quotes
- Import sorting: Automatic with `isort` integration
- Type hints: Encouraged for all functions

---

## Testing Guidelines

- Place tests in `tests/` directory
- Use naming conventions: `test_*.py`, `Test*` classes, `test_*` functions
- Write descriptive test names and include docstrings
- **Coverage Requirement**: 80% minimum for new/modified code (enforced in CI via diff-cover)
- Use pytest fixtures and parametrize for efficient testing
- Test both happy paths and edge cases

### Project Configuration

The project is configured through `pyproject.toml`, which includes:

- **Project metadata**: Name, version, description, authors, license
- **Dependencies**: Runtime and development dependencies
- **Tool configurations**: Settings for `ruff`, `pytest`, `pre-commit`, and `commitizen`

### Development Dependencies

- **pre-commit**: Git hook framework for code quality checks
- **ruff**: Fast Python linter and formatter
- **pytest**: Testing framework
- **pytest-cov**: Coverage plugin for pytest
- **pytest-mock**: Mocking utilities for pytest (if needed)
- **diff-cover**: Coverage analysis for changed lines
- **commitizen**: Conventional commits and version management

**Note**: This template has no runtime dependencies to keep it lightweight. Add dependencies as needed for your project.

---

## Continuous Integration & Deployment

This template includes a complete CI/CD pipeline using GitHub Actions with two main workflows:

### 1. CI - Lint and Test (`ci.yml`)

**Triggers:** Pull requests and pushes to `master` branch

**Jobs:**
- **Pre-commit Checks**: Linting and formatting validation
- **Test and Coverage**:
  - Matrix testing on Python 3.12 and 3.13
  - Enforces 80% coverage on new/modified lines (diff-cover)
  - Posts PR comment with coverage metrics and test results
  - Uploads HTML coverage reports (5-day retention)

**Key Features:**
- Automated PR comments with coverage breakdown per file
- Fails if new code coverage < 80%
- Detailed file-level coverage for changed code

### 2. Release Branch & PR (`release-branch.yml`)

**Triggers:** Manual workflow dispatch on `master`

**Inputs:**
- `version_bump`: Version increment type (`patch`/`minor`/`major`) — default: `patch`
- `custom_version`: Optional custom version string (e.g., `1.2.3`) — overrides bump type

**Process:**
1. Calculates the next version (or uses `custom_version`) via `uv version`
2. Updates the changelog using Commitizen: `cz changelog --unreleased-version <version>`
3. Bumps the project version using Commitizen: `cz bump --increment <type>` or `cz bump <version>`
4. Creates a release branch `release/v<version>`
5. Opens a Pull Request targeting `master`

This workflow does not publish artifacts or create a GitHub Release. After the PR is merged, use your organization’s publish/tagging process or a dedicated "Publish Release" workflow if configured.

### 3. Publish Release (`release-publish.yml`)
**Triggers:** Pushes on `master`

**Jobs:**
- **Verify Push**: Ensures the push is from a release merge
- **Build Package**: Builds the distribution package (sdist and wheel)
- **Publish Artifacts**: Publishes the package to JFrog Artifactory using the `JFROG_TOKEN` secret for authentication.
- **Create GitHub Release**: Tags the release and creates a GitHub Release entry with changelog notes.

**Key Features:**
- Automated publishing to Artifactory
- GitHub Release creation with changelog details
```

### Dependency Management

**Dependabot Configuration** (`dependabot.yml`):
- **Python dependencies**: Weekly updates on Tuesday
- **GitHub Actions**: Weekly updates on Wednesday
- Automatic labeling and conventional commit messages

### Code Owners

The `CODEOWNERS` file ensures proper review assignments:
- Default: `@nbnco/dsoe_dto_administrators`
- Customize for specific teams or file patterns

### Runner Configuration

**Note**: All workflows use `code-scanning` runner. Update the `runs-on` value in each workflow file to match your organization's runner configuration:

```yaml
runs-on: code-scanning  # TODO: change to your preferred runner
```

Common options: `ubuntu-latest`, `self-hosted`, or custom runner labels.

---

## Contributing

### Workflow

1. Create a feature branch
2. Make your changes
3. Write tests for your changes
4. Commit with conventional commit messages
5. Push (pre-push hooks will validate tests and coverage)
6. Create a pull request

**What Happens on Commit:**
- Code is automatically formatted with Ruff
- Code is linted with Ruff (issues auto-fixed where possible)
- File quality checks run (whitespace, YAML/JSON/TOML validation, etc.)
- Commit message is validated for conventional commit format
- Dependencies are checked against `uv.lock`

**What Happens on Push:**
- All tests run with coverage (push fails if tests fail)
- Diff-cover validates 80% coverage threshold on changed lines
- Push fails if new code doesn't meet coverage requirements
- Branch name is validated

### Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md). Please read and follow it in all interactions.

---

## Resources

- [uv Documentation](https://github.com/astral-sh/uv)
- [Ruff Documentation](https://docs.astral.sh/ruff/)
- [pytest Documentation](https://docs.pytest.org/)
- [Pre-commit Documentation](https://pre-commit.com/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Python Packaging Guide](https://packaging.python.org/)

---

## Support

For issues, questions, or contributions, please open an issue in the repository.
