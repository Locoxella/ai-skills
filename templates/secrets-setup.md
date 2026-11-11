# Safe Secret Generation & Injection Guide (`last-verified: 2026-11-11`)

Never store plaintext tokens, API keys, private keys, or passwords inside agent
rules, memories, skills, or tracked Git files. Generate secrets locally, isolate
them in gitignored files with `chmod 600`, and inject them at runtime.

## 1. Generating Cryptographic Keys & Tokens Locally

```bash
# Generate a 256-bit random hex secret (webhooks, HMAC, session keys)
openssl rand -hex 32

# Generate a URL-safe base64 token
openssl rand -base64 32 | tr '+/' '-_' | tr -d '='

# Generate a dedicated Ed25519 SSH key pair (do not commit the private key)
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_<service> -C "<service>-automation"
```

## 2. Isolating Secrets in `.env` or Protected Token Files

1. Verify `.env`, `*.env`, `secrets.*`, and `*.key` are ignored in `.gitignore`
   under `# Custom Project Rules`.
2. Write credentials with strict owner-only permissions:

   ```bash
   umask 077
   cat << 'EOF' > .env
   API_TOKEN=<PASTE_GENERATED_OR_PROVIDER_TOKEN>
   WEBHOOK_SECRET=<PASTE_OPENSSL_HEX_OUTPUT>
   EOF
   chmod 600 .env
   ```

3. Provide a tracked `.env.example` with placeholders only
   (`API_TOKEN=`, `HOST_URL=https://<HOST>`).

## 3. Injecting Secrets into CLIs, Services & CI/CD

| Runtime Context | Safe Injection Pattern |
| --- | --- |
| **Shell** | `set -a && source .env && set +a` or `$(cat token)` |
| **Systemd** | `EnvironmentFile=%h/.config/<app>/.env` in `[Service]` |
| **CLIs** | Run `gh auth login` or `tea login add` interactively |
| **CI/CD** | Use repo Secrets via `${{ secrets.MY_SECRET }}` |
| **Compose** | Reference `${VAR_NAME}` backed by a gitignored `.env` |
