set positional-arguments := true
set unstable := true

# Default recipe
default: lint

# Run all linters
lint: lint-docs lint-config lint-spelling

# Lint configuration files
lint-config: lint-json lint-yaml

# Lint documentation
lint-docs *args:
    just lint-markdown {{ args }}
    just lint-prose {{ args }}

# Lint JSON/JS/TS files
lint-json:
    biome check --files-ignore-unknown=true .

# Lint Markdown files
lint-markdown *args:
    rumdl check {{ if args == "" { "." } else { args } }}

# Lint prose in Markdown files
lint-prose *args:
    vale {{ if args == "" { "README.md" } else { args } }}

# Check spelling
lint-spelling:
    codespell

# Lint YAML files
lint-yaml:
    yamllint --strict .

# Format code
format: format-spelling format-config format-docs

# Format configuration files
format-config:
    biome format --write .

# Format documentation
format-docs *args:
    just format-markdown {{ args }}

# Format Markdown files
format-markdown *args:
    rumdl fmt {{ if args == "" { "." } else { args } }}

# Fix spelling
format-spelling *args:
    codespell -w {{ if args == "" { "." } else { args } }}

# Fix code issues
fix: fix-config fix-docs

# Fix configuration files
fix-config:
    biome check --write .

# Fix documentation
fix-docs *args:
    just fix-markdown {{ args }}

# Fix Markdown files
fix-markdown *args:
    rumdl check --fix {{ if args == "" { "." } else { args } }}

# Check that everything is ready for commit
check: lint

# Run pre-commit hooks on changed files
prek:
    prek

# Run pre-commit hooks on all files
prek-all:
    prek run --all-files

# Install pre-commit hooks
prek-install:
    prek install

# Sync Vale styles and dictionaries
vale-sync:
    vale sync
