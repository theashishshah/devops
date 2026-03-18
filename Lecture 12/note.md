# Continuous Integration with GitHub Actions

## What is Continuous Integration (CI)?

**Idea**: Automatically build, test, and validate code **frequently** (on every push/PR) so bugs are caught early **before merging** to main/prod branches.

**Why it matters**:
- Detects bugs and regressions quickly.
- Keeps the main branch always releasable.
- Enforces a consistent quality bar (lint, test, build).

---

## Core CI stages (Shift Left / DevSecOps mindset)

In CI we try to move checks **left** (closer to the developer):

1. **Linting**
   - Always set up a linter in the project (ESLint, flake8, etc.).
   - Enforces style and catches simple bugs automatically.

2. **Testing**
   - Run unit/integration tests on every push/PR.
   - Gives confidence that new code does not break existing behavior.

3. **Build**
   - Make sure the app / package can still build successfully.
   - For frontends: production build; for backends: compile, bundle, or at least install dependencies.

Tools like **Husky** can enforce lint + test + build **before pushing** (pre-commit / pre-push hooks), and GitHub Actions can re‑check the same things in CI on the server side.

---

## GitHub Actions basics

GitHub Actions runs workflows defined in YAML files under `.github/workflows/`.

- **Workflow**: top-level config that runs on certain events (e.g. `push`, `pull_request`).
- **Jobs**: independent units of work that can run in parallel.
- **Steps**: individual commands or reusable actions inside a job.
- **Strategy / matrix**: run the same job on multiple OS / language / version combinations.

Key terms from your notes:
- **jobs**: each job has a name and does some work (lint, test, build, deploy).
- **steps**: typically use `uses`, `with`, and `run`:
  - `uses`: reference a pre-built action (e.g. `actions/checkout@v4`).
  - `with`: pass inputs to that action.
  - `run`: execute shell commands.
- **strategy.matrix**: run tests on multiple Node/Python versions or OSes simultaneously.

Jobs in a workflow are **parallel by default**, unless you set dependencies with `needs`.

---

## Example CI workflow (Node.js project)

Minimal example: run lint + tests on pushes and pull requests to main branches.

```yaml
name: CI

on:
  push:
    branches: [ main, master ]
  pull_request:
    branches: [ main, master ]

jobs:
  build-and-test:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [18, 20]

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Use Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}

      - name: Install dependencies
        run: npm ci

      - name: Lint
        run: npm run lint

      - name: Test
        run: npm test
```

**What this does**:
- Triggers on `push` and `pull_request` to `main`/`master`.
- Runs one job `build-and-test` on `ubuntu-latest`.
- Uses a **matrix** to test on Node 18 and 20.
- Checks out code, installs deps, runs `npm run lint` and `npm test`.

---

## Production workflow considerations

When moving towards production:
- Protect the **main / production** branch (require PRs, status checks, reviews).
- Require **CI to pass** (lint, test, build jobs green) before merging.
- Optionally add:
  - Security scans (SAST / dependency checks).
  - Build artifacts (Docker images, bundles) and attach them to releases.
  - Separate **deploy** workflows that only run on tags or merges to main.

CI with GitHub Actions becomes the gatekeeper: no unhealthy code reaches your main/prod branches.

---

## Patterns commonly used in industry

- **Monorepo vs polyrepo pipelines**
  - Monorepos often use a **single workflow** with multiple jobs, and only run jobs for projects that changed (path filters, `if:` conditions).
  - Polyrepos usually keep one or more workflows per service/repo, each focused on that service.

- **Caching to speed up CI**
  - Use `actions/cache` (or language-specific actions) to cache:
    - `node_modules`, `.venv`, build artifacts, etc.
  - This makes repeated runs much faster, especially on large projects.

- **Environment-specific workflows**
  - One workflow for **PR validation** (lint, test, build).
  - Another workflow for **staging** deploys (runs on merge to `develop` or a staging branch).
  - A **production** workflow that runs only on tags or releases (e.g. `v*.*.*` tags).

- **Approvals and manual gates**
  - Use **environments** in GitHub (e.g. `staging`, `production`) with required reviewers.
  - CI can build and test automatically, but deploy jobs wait for a human approval step for sensitive environments.

- **Secrets and configuration**
  - Store secrets in **GitHub Secrets / Environment Secrets** (API keys, tokens, passwords).
  - Workflows read them via `${{ secrets.MY_SECRET }}` and never hard-code secrets in YAML.

- **Status checks and required jobs**
  - Protect branches so that critical jobs (e.g. `build-and-test`, `security-scan`) must succeed before merging.
  - Some orgs add a dedicated **quality gate** job that aggregates results from other jobs.

All of these patterns build on the same basics you already have: frequent lint/test/build runs, defined as code in GitHub Actions, controlling what can reach your main and production branches.
