# GLIMMER CAPE — Sensitive Data Catalog & Masking (Shared Item, bought by ELDER TITAN for VIPER, ORACLE for SHADOW FIEND, and SILENCER for every document)

One catalog of what counts as sensitive, so all three lanes guard the same values. **ELDER TITAN** buys it when assembling `VIPER`, **ORACLE** when assembling `SHADOW FIEND`, and **SILENCER** for every document it filters.

## 1. Sensitive Data Catalog
| Class | Values | Fake placeholder (same shape) |
| :--- | :--- | :--- |
| **Secrets** | Passwords, PINs, API keys, private keys, JWTs and session tokens, signing secrets, connection strings with credentials, pre-signed URLs | `<JWT>`, `<API_KEY>`, `<PASSWORD>`, `postgres://<user>:<password>@db.example.com/app` |
| **Personal data** | National ID / passport numbers, an individual's tax ID, full names tied to records, emails, phone numbers, addresses, dates of birth | `0000000000000`, `Somchai Example`, `user@example.com`, `000-000-0000` |
| **Financial data** | Card numbers, bank account numbers, payment payloads tied to a person | `4111 1111 1111 1111` (published test card), `000-0-00000-0` |
| **Internal infrastructure** | Internal hostnames, private IPs, cluster/namespace names, internal URLs | `api.example.com`, `192.0.2.10` |

Internal infrastructure counts as sensitive only where the audience is outside the team (public docs, partner deliverables, error responses to callers).

## 2. How Each Lane Uses It
- **🔨 `VIPER` (Top Lane):** for each catalog value the planned flow carries, name where it is redacted or excluded (logs, audit tables, error responses, outbound calls).
- **🔮 `SHADOW FIEND` (Mid Lane):** flag catalog values hardcoded in source, tests, fixtures or committed config, and catalog values reaching logs, exceptions, telemetry or error responses unredacted.
- **📖 `SILENCER` (Bot Lane, rule 8):** replace every catalog value in examples, tables and code blocks with its placeholder, and list each one in the `🔒 MASKED` report.

## 3. Masking Rules
1. **Same shape, obviously fake:** a placeholder keeps the value's format so examples still read correctly, and uses reserved values (`example.com` per RFC 2606, `192.0.2.0/24` per RFC 5737, published test cards).
2. **Never echo the original:** findings and reports name the location and the class (`app/conf/application.conf:12 — API key`), never the value itself.
