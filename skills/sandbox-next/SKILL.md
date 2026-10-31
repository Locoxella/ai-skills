---
name: sandbox-next
description: Use when building or changing Cloudflare Sandbox apps on @cloudflare/sandbox 1.0+ (current GA / latest) or @next—code execution, process handles, AI runners, interpreters, CI-like jobs, terminals, files, mounts, tunnels, preview URLs, lifecycle, or errors. For legacy 0.12.x apps, use sandbox-stable.
---

# Sandbox SDK — 1.0 (GA / Current Stable) & `@next`

Isolated Linux environments on [Cloudflare Containers](https://developers.cloudflare.com/containers/), driven from Workers.

**Prefer latest docs and installed types over memory.** APIs change; this skill is a gate, a contract, and a retrieval map—not a full manual.

> [!NOTE]
> Sandbox SDK 1.0+ is now GA (General Availability) and the default `latest` release on npm (`npm i @cloudflare/sandbox`). This skill covers the modern 1.0+ process-handle model and `@next` preview builds.

We recommend **new projects** on this line (1.0+ GA). Legacy apps still on 0.12.x use **`sandbox-stable`**. Port legacy apps via **`sandbox-migrate-to-next`**.

## 1. Gate — confirm the package line

Before writing code, inspect the app:

| Check | Must match |
| ----- | ---------- |
| npm dependency | `@cloudflare/sandbox` >= 1.0.0 (or `@next`) |
| Container image | Modern 1.0/next line (e.g. `cloudflare/sandbox:latest`, `cloudflare/sandbox:next`, `next-python`) |

| If you find… | Action |
| ------------ | ------ |
| Legacy `@cloudflare/sandbox` <1.0.0 (0.12.x) | **Stop.** Load **`sandbox-stable`**. Do not apply 1.0 handle APIs to 0.12.x. |
| User wants to port legacy 0.12.x → 1.0+ | **Stop.** Load **`sandbox-migrate-to-next`**. |
| Self-deployed **bridge** only | Bridge is **not** on the 1.0 line yet. Keep bridge on legacy 0.12.x package + image. [Bridge](https://developers.cloudflare.com/sandbox/bridge/) |

Never mix an `@next` Worker package with a stable container image (or the reverse).

Skills install: [Agent setup](https://developers.cloudflare.com/agent-setup/) · [cloudflare/skills](https://github.com/cloudflare/skills)

## 2. Contract — non-negotiables

- `sandbox.exec(argv)` takes an **argv** list and resolves when the process **starts**. It returns a **handle**, not a finished command result.
- Collect results with handle methods: `output()`, `logs()`, `waitForExit()`, `waitForPort()`, `waitForLog()`, `kill(signal?)`.
- No implicit shell. Shell syntax needs an explicit shell, e.g. `["/bin/bash", "-lc", script]`.
- Each launch is independent. A `cd` / `export` in one `exec` is not visible to the next. Pass `cwd` and `env` per launch, or one shell script.
- Process handles have **no stdin**. Interactive use → terminals (`createTerminal` + `connect`).
- Local wait `timeout` / `AbortSignal` cancel the **wait only**. They do not kill the process. Use `kill` or `exec`’s remote `timeout`.
- `getProcess` / `listProcesses` / `getTerminal` / `listTerminals` do **not** start a container; they return `null` / `[]` when none is up.
- Process and terminal IDs belong to the **current container**, not forever to a sandbox ID. For work that must survive replace, store the full job (argv, cwd, env, app state)—not only an id.
- Non-secret config only in `setEnvVars` / launch `env`. Live credentials stay in the Worker; use outbound handlers when the sandbox calls external APIs.
- Do **not** invent removed stable APIs (`gitCheckout` on core, string-`exec` completion, session execution, `sandbox.terminal(request)`).
- Do **not** use one retry loop for every error (see Errors docs).

Minimal shape:

```ts
import { getSandbox, proxyToSandbox, Sandbox } from "@cloudflare/sandbox";

export { Sandbox };

const sandbox = getSandbox(env.Sandbox, "user-123");
const process = await sandbox.exec(["python3", "-c", "print(2 + 2)"]);
const result = await process.output({ encoding: "utf8" });
// result.stdout, result.exitCode
```

Optional **non-exhaustive** cheatsheet (process/terminal/interpreter only): [references/api-quick-ref.md](references/api-quick-ref.md)  
Examples index (`next` branch): [references/examples.md](references/examples.md)

## 3. Retrieve — open the doc for the task

Fetch the page before implementing. Installed `@next` types win over guesses.

| You need to… | Open |
| ------------ | ---- |
| Orient / choose preview | [1.0 preview overview](https://developers.cloudflare.com/sandbox/1-0-preview/) |
| First Worker, wrangler, Dockerfile | [Get started](https://developers.cloudflare.com/sandbox/1-0-preview/get-started/) |
| `exec`, handles, readiness, durability | [Process execution](https://developers.cloudflare.com/sandbox/1-0-preview/processes/) |
| Process API signatures | [Processes API](https://developers.cloudflare.com/sandbox/1-0-preview/api/processes/) |
| Sandbox ID vs container vs sleep/destroy | [Lifecycle](https://developers.cloudflare.com/sandbox/1-0-preview/lifecycle/) |
| `cwd` / `env` / `setEnvVars` | [Environment](https://developers.cloudflare.com/sandbox/1-0-preview/environment/) |
| Interactive PTY / browser terminal | [Terminals](https://developers.cloudflare.com/sandbox/1-0-preview/terminals/) · [Terminals API](https://developers.cloudflare.com/sandbox/1-0-preview/api/terminals/) |
| Python/JS code interpreter | [Interpreter](https://developers.cloudflare.com/sandbox/1-0-preview/interpreter/) · [Interpreter API](https://developers.cloudflare.com/sandbox/1-0-preview/api/interpreter/) |
| Extensions model | [Extensions](https://developers.cloudflare.com/sandbox/1-0-preview/extensions/) |
| Error classes and recovery | [Errors](https://developers.cloudflare.com/sandbox/1-0-preview/errors/) · [Errors API](https://developers.cloudflare.com/sandbox/1-0-preview/api/errors/) |
| Common failures | [Troubleshooting](https://developers.cloudflare.com/sandbox/1-0-preview/troubleshooting/) |
| API hub | [API reference](https://developers.cloudflare.com/sandbox/1-0-preview/api/) |
| Files, mounts, backups, ports, tunnels, `proxyToSandbox` | Main docs for shared surfaces (ignore stable-only session/transport/`sandbox.terminal`): [Files](https://developers.cloudflare.com/sandbox/api/files/) · [Storage / mounts](https://developers.cloudflare.com/sandbox/api/storage/) · [Ports](https://developers.cloudflare.com/sandbox/api/ports/) · [Tunnels](https://developers.cloudflare.com/sandbox/api/tunnels/) · [Backups](https://developers.cloudflare.com/sandbox/api/backups/) · [Outbound traffic](https://developers.cloudflare.com/sandbox/guides/outbound-traffic/) · [Expose services](https://developers.cloudflare.com/sandbox/guides/expose-services/) · [Production](https://developers.cloudflare.com/sandbox/guides/production-deployment/) |
| Example apps | [examples on `next`](https://github.com/cloudflare/sandbox-sdk/tree/next/examples) |
| Still on stable package | **`sandbox-stable`** · [Main Sandbox docs](https://developers.cloudflare.com/sandbox/) |
| Porting an existing stable app | **`sandbox-migrate-to-next`** · [Migrate](https://developers.cloudflare.com/sandbox/1-0-preview/migrate/) |

## 4. Before you ship

- Lockfile and Dockerfile on the **same** `@next` line  
- Typecheck against installed `@next` types  
- No live secrets in sandbox env  
- Production preview hostnames need wildcard DNS on a custom domain when using those URL patterns  
