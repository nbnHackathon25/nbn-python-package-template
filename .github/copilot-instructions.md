# NBN Python Package Template - AI Agent Guide

## Project Context
This is an **opinionated Python project template** for NBN Co repositories. It enforces modern Python practices with `uv` for dependency management, strict testing/coverage requirements, and automated CI/CD workflows.

## Critical Architecture Decisions

### Package Management: `uv` (Not pip/poetry)
- **All Python commands** must use `uv run <command>` (e.g., `uv run pytest`, `uv run python`)
- Dependencies are defined in `pyproject.toml` with PEP 621 standard
- Runtime deps: `dependencies = []`, dev deps: `[dependency-groups] dev = [...]`
- Lock file (`uv.lock`) is auto-generated and committed
- Add deps: `uv add <package>` (runtime) or `uv add --dev <package>` (dev)

### Strict Testing Requirements (Non-Negotiable)
- **80% coverage on new/changed lines** enforced by `diff-cover` in pre-push hooks and CI
- Coverage measured against `origin/master` branch
- Tests run automatically on pre-push (blocks push if failing)
- Configuration: `pyproject.toml` under `[tool.pytest.ini_options]` and `[tool.coverage]`
- Generated artifacts: `coverage.xml`, `htmlcov/`, `newline_report.md`

### Pre-commit Hook Stages (Three-Stage Design)
1. **pre-commit**: Formatting (Ruff), linting (Ruff), file checks, no tests
2. **commit-msg**: Conventional commit validation, `uv.lock` sync
3. **pre-push**: Full test suite + diff-cover validation (can take 10-30s)

This design keeps commits fast while ensuring quality before push.

## Developer Workflows

### Essential Scripts (Use These, Not Manual Commands)
Located in `scripts/` with helper modules in `scripts/helpers/`:
- `./scripts/setup.sh` - First-time setup (installs uv, deps, hooks)
- `./scripts/run_tests.sh [branch]` - Run tests + diff-cover (default: origin/master)
- `./scripts/lint.sh` - Ruff format + check only
- `./scripts/run_precommit.sh` - Run all pre-commit hooks manually
- `./scripts/build.sh` - Build wheel/sdist for distribution
- `./scripts/clean.sh [--all]` - Clean artifacts (keeps .venv unless --all)

**Why scripts?** They encapsulate `uv` checks, error handling, and environment validation that manual commands miss.

### Commit Message Enforcement
- **Conventional Commits required** (enforced by commitizen hook)
- Format: `<type>[optional scope]: <description>` (e.g., `feat: add user auth`, `fix(api): handle timeout`)
- Common types: `feat`, `fix`, `docs`, `refactor`, `test`, `ci`, `chore`
- Interactive mode: `uv run cz commit` (prompts for type/scope/message)
- Commit messages are validated on `commit-msg` hook - invalid commits are rejected

### CI/CD Pipeline (GitHub Actions)
Three workflows in `.github/workflows/`:
1. **ci.yml**: Runs on PRs/pushes to master - pre-commit checks + matrix testing (Python 3.12, 3.13) + posts coverage comment to PRs
2. **release-branch.yml**: Manual workflow to create release PR - runs `cz changelog` + `cz bump`, creates `release/v<version>` branch
3. **release-publish.yml**: Triggered on master push from release merge - publishes to JFrog Artifactory + creates GitHub Release

**Coverage reporting**: CI posts PR comments with overall coverage + diff-cover breakdown per file.

## Project-Specific Conventions

### Source Layout (src-layout pattern)
```
src/nbn_dummy_package/  # Package code here (rename for your project)
tests/                  # Test files (test_*.py pattern)
scripts/                # Development automation
  helpers/              # Reusable bash functions (python.sh, common.sh, print.sh)
```

**Key pattern**: Package name in `pyproject.toml` (`nbn-dummy-package`) != module name (`nbn_dummy_package`). Module name uses underscores, package name uses hyphens.

### CLI Entry Points
Defined in `pyproject.toml` under `[project.scripts]`:
```toml
[project.scripts]
nbn-hello = "nbn_dummy_package.hello:main"
```
After install: `nbn-hello` command calls `main()` in `src/nbn_dummy_package/hello.py`.

### Ruff Configuration (pyproject.toml)
- Line length: 120 chars (not 88 like Black)
- Selected rules: `E`, `F`, `W` (pycodestyle), `B` (bugbear), `C4` (comprehensions), `I` (isort), `UP` (pyupgrade)
- Auto-fix enabled in pre-commit
- `__init__.py` files excluded from linting

### Coverage Exclusions
From `[tool.coverage.report]`:
- `pragma: no cover` comments
- `if __name__ == "__main__":` blocks (see `src/nbn_dummy_package/hello.py` example)

## Integration Points

### External Dependencies
- **JFrog Artifactory**: Package publishing target (requires `JFROG_TOKEN` secret)
- **Commitizen**: Version bumping + changelog generation (reads `pyproject.toml` version)
- **Diff-cover**: Coverage comparison against git branches (requires git history in CI)

### GitHub Actions Configuration
- Default runner: `ubuntu-latest` (change `runs-on` in workflows if using custom runners)
- Requires `fetch-depth: 0` in checkout for diff-cover to access branch history
- PR comments require `pull-requests: write` permission

## Common Patterns

### Adding a New Feature Module
1. Create `src/nbn_dummy_package/new_feature.py`
2. Create `tests/test_new_feature.py` with 80%+ coverage
3. Run `./scripts/run_tests.sh` to verify coverage threshold
4. Commit with conventional format: `feat: add new feature`

Note: If used as a template please rename `nbn_dummy_package` to your actual package name throughout the project.

### Debugging Test Failures
```bash
# Run specific test with verbose output
uv run pytest tests/test_file.py::test_name -vv

# Run with debugger on first failure
uv run pytest --pdb

# Check coverage for specific module
uv run pytest --cov=src/nbn_dummy_package.module --cov-report=term-missing
```

### Bypassing Hooks (Emergency Only)
```bash
git commit --no-verify  # Skip pre-commit/commit-msg hooks
git push --no-verify    # Skip pre-push hooks (tests won't run!)
```

## When Helping Users

### Always Prefer
- Using `uv run` over direct Python/pip commands
- Running scripts (`./scripts/*.sh`) over manual command sequences
- Checking `pyproject.toml` for configuration before suggesting changes
- Writing tests alongside feature code (not as an afterthought)

### Never
- Suggest `pip install` or `poetry add` (use `uv add` instead)
- Bypass pre-commit hooks without explaining risks
- Recommend coverage below 80% for new code
- Hardcode secrets (use env vars or secrets management)

### Red Flags to Watch For
- Missing test files for new Python modules
- Coverage reports showing <80% on changed lines
- Commit messages not following conventional format
- Direct dependency installation without updating `pyproject.toml`
