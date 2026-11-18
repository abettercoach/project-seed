# Every command for this project. Run `just` to list them. Tools come from mise (mise.toml).
# Seed skeleton: each recipe says so until the project's stack fills it in.

# List recipes
default:
    @just --list

# Install all dependencies from the lockfiles (run once, and after pulling)
setup:
    @echo "setup: no dependencies yet"

# Run the app in dev mode
dev:
    @echo "dev: nothing to run yet"

# Lint, typecheck, and test: run before every PR
check: lint typecheck test

# Run all tests
test:
    @echo "test: no tests yet"

# Lint and format check (no changes)
lint:
    @echo "lint: nothing to lint yet"

# Typecheck
typecheck:
    @echo "typecheck: nothing to typecheck yet"

# Fix formatting and safe lint issues
fmt:
    @echo "fmt: nothing to format yet"
