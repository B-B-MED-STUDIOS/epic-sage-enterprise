# ══════════════════════════════════════════════
# EPIC // S.A.G.E — Sovereign Makefile
# BUILT BY M.E.D | v4.0.0
# ══════════════════════════════════════════════

.PHONY: help dev test lint build release clean keys

help:
	@echo ""
	@echo " EPIC // S.A.G.E — BUILT BY M.E.D"
	@echo " make dev        Start full stack (Docker)"
	@echo " make test       Run backend + frontend tests"
	@echo " make lint       Lint backend (ruff) + frontend (eslint)"
	@echo " make build      Build Docker images"
	@echo " make keys       Generate sovereign keys"
	@echo " make clean      Remove containers and volumes"
	@echo ""

keys:
	@echo "AUDIT_SIGNING_KEY=$(shell python3 -c 'import secrets; print(secrets.token_hex(64))')"
	@echo "JWT_SECRET_KEY=$(shell python3 -c 'import secrets; print(secrets.token_hex(32))')"

dev:
	docker compose up --build

test:
	cd backend && pip install -r requirements.txt -q && pytest tests/ -v --tb=short
	cd frontend && npm install -q && npm test

lint:
	cd backend && ruff check app/
	cd frontend && npm run lint

build:
	docker build -f infra/docker/Dockerfile.backend -t epic-sage-backend:latest .
	docker build -f infra/docker/Dockerfile.frontend -t epic-sage-frontend:latest .

clean:
	docker compose down -v --remove-orphans
