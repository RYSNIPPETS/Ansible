# Ansible Administration Playbooks

A collection of small, single-purpose Ansible playbooks for day-to-day fleet
administration: connectivity and preflight checks, fact gathering, file and user
management, package and service operations, and inventory tooling.

The repository contains 18 playbooks, a sample inventory, and a YAML-to-JSON helper. It
is a playbook library rather than a single role or application, so each playbook has its
own purpose, extra variables, and privilege requirements.

## Playbook categories

| Location | Playbooks | What they cover |
| --- | ---: | --- |
| [`Connectivity/`](https://github.com/RYSNIPPETS/Ansible/tree/main/Connectivity/) | 3 | Reachability and preflight: ping, waiting for hosts after a reboot, and verifying privilege escalation. |
| [`Facts/`](https://github.com/RYSNIPPETS/Ansible/tree/main/Facts/) | 3 | Gathering host facts, a one-line OS summary, and disk-usage reporting. |
| [`Files/`](https://github.com/RYSNIPPETS/Ansible/tree/main/Files/) | 3 | Ensuring files exist, copying files to hosts, and managing directories. |
| [`Users/`](https://github.com/RYSNIPPETS/Ansible/tree/main/Users/) | 3 | Showing the remote user, creating users, and listing local login accounts. |
| [`Packages/`](https://github.com/RYSNIPPETS/Ansible/tree/main/Packages/) | 2 | Installing packages with the OS-appropriate manager and listing what is installed. |
| [`Services/`](https://github.com/RYSNIPPETS/Ansible/tree/main/Services/) | 3 | Reporting service state, restarting a service, and enabling one at boot. |
| [`Inventory/`](https://github.com/RYSNIPPETS/Ansible/tree/main/Inventory/) | 1 | Listing the inventory as Ansible sees it, plus a sample inventory and a YAML-to-JSON helper. |

### Repository organization

Playbooks are grouped by administrative purpose. The repository root is reserved for
documentation and repository-wide configuration: [`ansible.cfg`](ansible.cfg) holds the
shared defaults (default inventory and YAML-formatted results), the sample inventory and
the `convert-yaml-to-json.sh` helper live in [`Inventory/`](https://github.com/RYSNIPPETS/Ansible/tree/main/Inventory/), and validation
lives in [`Tests/`](Tests/).

Every playbook is self-documenting: its header comment states what it does, how to run
it, and which extra variables (`-e key=value`) it accepts. All tasks use fully-qualified
`ansible.builtin` module names, so no extra collections are required.

## Requirements and compatibility

- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html)
  (ansible-core 2.15 or newer)
- A control node with Python 3 and SSH access to the managed hosts
- Python 3 with [PyYAML](https://pyyaml.org/) for the inventory helper and the test
  baseline
- `sudo`/`become` configured on the managed hosts for the playbooks that change system
  state

Managed hosts are selected through the inventory. Point Ansible at your own inventory
with `-i your-hosts.yml`, or edit the `inventory` line in [`ansible.cfg`](ansible.cfg).
Review a playbook's header comment and tasks before running it, particularly against
production hosts.

## Repository validation

Run the repository checks from its root:

```bash
make check
```

The validation always verifies that every YAML file is well-formed (via PyYAML) and that
the shell scripts pass `bash -n`, are executable, and answer `--help`. When the full
Ansible toolchain is installed, it additionally runs `ansible-playbook --syntax-check`,
`yamllint`, `ansible-lint`, and `shellcheck`; each is skipped with a notice when its tool
is not present.

## Getting started

Clone the repository:

```bash
git clone https://github.com/RYSNIPPETS/Ansible.git
cd Ansible
```

The bundled sample inventory includes a local `control` group, so a read-only playbook
runs immediately with no remote hosts and no SSH:

```bash
ansible-playbook Connectivity/ping.yml --limit control
```

List the inventory as Ansible sees it (this runs on the control node):

```bash
ansible-playbook Inventory/list-hosts.yml
```

Point at your own hosts and summarize their operating systems:

```bash
ansible-playbook -i your-hosts.yml Facts/os-summary.yml
```

## Important safety notice

Some playbooks change managed hosts — creating users, installing packages, restarting
services, or writing files. Before running one against production:

1. Read the playbook's header comment and tasks, and confirm the extra variables it
   accepts.
2. Confirm which hosts you are targeting, and scope the run with `--limit`.
3. Preview changes with `--check --diff` — a dry run that reports what would change
   without changing anything.
4. Test against a non-production host or the local `control` group first.
5. Use an account with only the privileges the task requires.

Do not commit passwords, SSH private keys, or other secrets to the repository. Store
sensitive values with
[`ansible-vault`](https://docs.ansible.com/ansible/latest/vault_guide/index.html) and
reference them as variables, as shown in
[`Inventory/hosts.sample.yml`](https://github.com/RYSNIPPETS/Ansible/blob/main/Inventory/hosts.sample.yml).
