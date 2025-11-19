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

# Install dependencies
uv sync --all-groups

# Install pre-commit hooks
uv run pre-commit install --hook-type pre-commit --hook-type pre-push --hook-type commit-msg
```

### Usage

```bash
# Run the application (update with your actual command)
uv run python src/nbn_dummy_package/hello.py

# Or run as a module
uv run python -m nbn_dummy_package.hello
```

## Development

### Running Tests

```bash
# Run all tests
uv run pytest -v

# Run with coverage
uv run pytest --cov=src --cov-report=term-missing

# Run specific test file
uv run pytest tests/test_hello.py

# Run specific test class or function
uv run pytest tests/test_hello.py::TestGreet::test_greet_parametrized

# Run diff-cover to check coverage on changed lines
uv run diff-cover coverage.xml --compare-branch=origin/master --format markdown:newline_report.md --fail-under=80
```

### Code Quality

```bash
# Run linting and formatting
uv run ruff check --fix
uv run ruff format

# Run all pre-commit hooks
uv run pre-commit run --all-files
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
1. Go to Actions → `2. Create Release PR [Manual]`
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
