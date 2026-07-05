#!/usr/bin/env python3
"""
extract_names.py <root_dir>

Walks root_dir for .lean files and extracts every top-level theorem/lemma
declaration name (comment-stripped, so text inside /- -/ or -- comments is
never mistaken for a real declaration).

Output: one line per declaration, tab-separated:
    relative/path.lean<TAB>kind<TAB>name

This is the input list that make_axiom_probe.py turns into a real
`#print axioms` probe file, and that parse_axiom_output.py cross-checks
the real compiler output against.
"""
import os
import re
import sys

TOP_DECL_RE = re.compile(
    r'^\s*(?:@\[.*?\]\s*)?(?:private |protected |noncomputable )*(theorem|lemma)\s+'
    r'([^\s:({\[]+)',
    re.MULTILINE,
)


def strip_lean_comments(text: str) -> str:
    out = []
    i = 0
    depth = 0
    n = len(text)
    while i < n:
        if text[i:i + 2] == '/-':
            depth += 1
            i += 2
            continue
        if depth > 0:
            if text[i:i + 2] == '-/':
                depth -= 1
                i += 2
                continue
            i += 1
            continue
        out.append(text[i])
        i += 1
    stripped = ''.join(out)
    lines = []
    for line in stripped.split('\n'):
        idx = line.find('--')
        if idx != -1:
            line = line[:idx]
        lines.append(line)
    return '\n'.join(lines)


def main():
    if len(sys.argv) != 2:
        print("usage: extract_names.py <root_dir>", file=sys.stderr)
        sys.exit(1)
    root = sys.argv[1]
    for dirpath, dirnames, filenames in os.walk(root):
        if '.lake' in dirpath.split(os.sep) or '.git' in dirpath.split(os.sep):
            continue
        for fn in filenames:
            if not fn.endswith('.lean'):
                continue
            full = os.path.join(dirpath, fn)
            rel = os.path.relpath(full, root)
            try:
                with open(full, encoding='utf-8', errors='ignore') as f:
                    text = f.read()
            except OSError:
                continue
            stripped = strip_lean_comments(text)
            for m in TOP_DECL_RE.finditer(stripped):
                kind, name = m.group(1), m.group(2)
                print(f"{rel}\t{kind}\t{name}")


if __name__ == '__main__':
    main()
