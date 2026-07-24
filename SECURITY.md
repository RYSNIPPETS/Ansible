# Security Policy

## Supported Code

This repository does not publish versioned releases. Security fixes are applied only to
the current code on the default branch.

| Code | Supported |
| --- | --- |
| Current `main` branch | Yes |
| Older commits or copies | No |

Pull the latest version before reporting a vulnerability or applying a security fix.

## Reporting a Vulnerability

Please do not disclose suspected security vulnerabilities in a public GitHub issue,
discussion, or pull request.

Use GitHub's private vulnerability reporting feature:

1. Open the repository's **Security** tab.
2. Select **Report a vulnerability**.
3. Submit the report privately.

Please include, when applicable:

- The affected playbook and task
- A description of the vulnerability and its potential impact
- The conditions required to reproduce it
- Reproduction steps or a minimal proof of concept
- Any suggested mitigation or fix

Do not include SSH private keys, vault passwords, `become` passwords, unredacted
inventory, or other sensitive data. Replace sensitive values with clearly marked
placeholders.

## What Qualifies as a Security Vulnerability

Examples include:

- Command or template injection through untrusted variables
- Exposure of credentials, vault passwords, or private keys
- Operations affecting hosts other than those selected by the inventory or `--limit`
- Bypassing an execution preview (`--check`) or confirmation safeguard
- Destructive behavior that is not clearly documented
- Requiring broader privileges than a playbook's header comment claims

General bugs, feature requests, documentation problems, and expected behavior should be
reported through the public issue tracker.

## Response Process

The maintainer aims to:

- Acknowledge a report within 7 days
- Provide an initial assessment within 14 days
- Request additional information when needed
- Coordinate any fix and public disclosure with the reporter

These response times are targets rather than guaranteed service levels. Please allow a
reasonable remediation period before publicly disclosing an accepted vulnerability.

## Shared Responsibility

These playbooks rely on Ansible, its Python interpreter, SSH, local credentials, and the
configuration of the managed hosts. Vulnerabilities in Ansible itself should be reported
to its maintainers. Configuration mistakes, overly broad `sudo` rules, or insecure
inventory outside this repository are generally outside this project's scope.
