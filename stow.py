#!/usr/bin/env python3

import os
import yaml
import sys

pkg = sys.argv[1].strip()

# Load config
with open('./stow-rules.yml', 'r') as f:
    config = yaml.safe_load(f)
global_rules = config.get('global', {})
individual_rules = config.get('rules', {}).get(pkg, {})
if isinstance(individual_rules, str):
    individual_rules = {'.': individual_rules}
rules = {**global_rules, **individual_rules}
# Varible substition
rules = {k: v.replace('[pkg]', pkg) for k, v in rules.items()}

# All subdirs of pkg to be stowed separately (non-recursive)
dirs = [f for f in os.listdir(pkg)
        if os.path.isdir(os.path.join(pkg, f)) and f in rules]

# Stow sub dirs
for sub_dir in dirs:
    target_dir = rules[sub_dir]
    os.system(f'mkdir -p {target_dir}'
              f' && stow -t {target_dir} -d {pkg} {sub_dir}')

# Stow base dirs
ignore_list = '\n'.join(map(lambda dir: f'{dir}/*', dirs))
ignore_file = f'{pkg}/.stow-local-ignore'
os.system(f'echo "{ignore_list}" > {ignore_file}')
target_dir = rules['.']
os.system(f'mkdir -p {target_dir} && stow -t {target_dir} {pkg}')
os.system(f'rm {ignore_file}')
