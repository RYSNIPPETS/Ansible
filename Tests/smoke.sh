#!/usr/bin/env bash
set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."
export ANSIBLE_CONFIG="$PWD/ansible.cfg"

inventory=Inventory/hosts.sample.yml
converter=Inventory/convert-yaml-to-json.sh
playbooks=(Connectivity/*.yml Facts/*.yml Files/*.yml Inventory/list-hosts.yml
  Packages/*.yml Services/*.yml Users/*.yml)

for script in "$converter" Tests/smoke.sh; do
  test -x "$script" || { printf 'Not executable: %s\n' "$script" >&2; exit 1; }
  bash -n "$script"
done
"$converter" --help >/dev/null

python3 - "$inventory" "$converter" _config.yml <<'PY'
import json
from pathlib import Path
import subprocess
import sys

import yaml

inventory, converter, pages_config = sys.argv[1:]
yaml.safe_load(Path(pages_config).read_bytes())
sample = Path(inventory).read_bytes()
expected = yaml.safe_load(sample)
from_file = subprocess.check_output([converter, inventory])
from_stdin = subprocess.check_output([converter], input=sample)
if json.loads(from_file) != expected or from_stdin != from_file:
    sys.exit("Inventory conversion produced unexpected JSON")
PY

ansible-config validate
ansible-inventory -i "$inventory" --list >/dev/null
for playbook in "${playbooks[@]}"; do
  ansible-playbook -i "$inventory" --syntax-check "$playbook"
done

if command -v yamllint >/dev/null; then
  yamllint "${playbooks[@]}" "$inventory" _config.yml
fi
if command -v ansible-lint >/dev/null; then
  ansible-lint "${playbooks[@]}"
fi
if command -v shellcheck >/dev/null; then
  shellcheck "$converter" Tests/smoke.sh
fi
