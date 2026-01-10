SHELL := /usr/bin/env bash
REPO_ROOT := $(shell pwd)

.PHONY: help bootstrap install uninstall lint fmt check test security secrets ci doctor

help:
	@echo "Targets:"
	@echo "  make bootstrap   Install dev tools (macOS via brew if available)"
	@echo "  make doctor   	  Run scripts/doctor.sh"
	@echo "  make install     Run scripts/install.sh"
	@echo "  make uninstall   Run scripts/uninstall.sh"
	@echo "  make fmt         Format shell scripts (shfmt)"
	@echo "  make lint        Lint shell scripts (shellcheck)"
	@echo "  make secrets     Scan for secrets (gitleaks)"
	@echo "  make security    Security scan (trivy fs)"
	@echo "  make check       Run fmt + lint"
	@echo "  make ci          Run check + secrets + security"

doctor:
	@./scripts/doctor.sh

bootstrap:
	@./scripts/bootstrap.sh

install:
	@./scripts/install.sh --force

uninstall:
	@./scripts/uninstall.sh

# ---------- Dev quality ----------
SHELL_FILES := $(shell find . -type f -name "*.sh" -o -name "*.zsh" | grep -vE '(^./\.git/|^./vendor/|^./node_modules/)' || true)

fmt:
	@command -v shfmt >/dev/null 2>&1 || { echo "Missing shfmt. Install: brew install shfmt"; exit 1; }
	@shfmt -w -i 2 -ci $(SHELL_FILES)

lint:
	@command -v shellcheck >/dev/null 2>&1 || { echo "Missing shellcheck. Install: brew install shellcheck"; exit 1; }
	@shellcheck -x $(SHELL_FILES)

check: fmt lint

# ---------- Security ----------
secrets:
	@command -v gitleaks >/dev/null 2>&1 || { echo "Missing gitleaks. Install: brew install gitleaks"; exit 1; }
	@gitleaks detect --redact --no-git -v

security:
	@command -v trivy >/dev/null 2>&1 || { echo "Missing trivy. Install: brew install trivy"; exit 1; }
	@trivy fs --scanners vuln,secret,config --ignore-unfixed --exit-code 1 --severity HIGH,CRITICAL .

ci: check secrets security
