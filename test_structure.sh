#!/usr/bin/env bash
# Fail if the tree is not a marketplace-shaped bar widget.
set -euo pipefail
cd "$(dirname "$0")"

fail() { echo "fail: $*" >&2; exit 1; }

[[ -f LICENSE ]] || fail "LICENSE missing"
[[ -f README.md ]] || fail "README missing"
[[ -f CHANGELOG.md ]] || fail "CHANGELOG missing"
[[ -f BarWidget.qml ]] || fail "BarWidget.qml missing"
[[ -f preview.png ]] || fail "preview.png missing"
[[ -f manifest.json ]] || fail "manifest.json missing"

python3 - << 'PY' || fail "manifest"
import json
import pathlib
import sys

manifest = json.loads(pathlib.Path("manifest.json").read_text())
errors = []

def need(cond, message):
    if not cond:
        errors.append(message)

need(manifest.get("schemaVersion") == 1 and isinstance(manifest.get("schemaVersion"), int), "schemaVersion")
need(manifest.get("id") == "jordan.workspaces", "id")
need(manifest.get("version") == "1.0.2", "version")
need(manifest.get("license") == "MIT", "license")
need("bar-widget" in manifest.get("kinds", []), "kinds")
entry = manifest.get("entryPoints", {}).get("barWidget")
need(entry == "BarWidget.qml", "entryPoints.barWidget")
need(pathlib.Path(entry or "").is_file(), "entry file")
need(".." not in str(entry), "entry path")
bar = manifest.get("barWidget") or {}
need(bar.get("defaultSection") in ("left", "center", "right"), "defaultSection")
need(bar.get("allowMultiple") is False, "allowMultiple")
need("omarchy" not in manifest, "clonedFrom")
description = manifest.get("description") or ""
need("other screen" not in description, "stale description")
need("Brackets mark the workspace that screen is showing" in description, "description")
if errors:
    print("\n".join(errors), file=sys.stderr)
    sys.exit(1)
PY

grep -q -F 'omarchy plugin remove jordan.workspaces' README.md || fail "README missing remove command"
grep -q -F 'omarchy plugin add https://github.com/jordanpartridge/omarchy-workspaces.git' README.md || fail "README missing add URL"
grep -q -F 'omarchy plugin disable omarchy.workspaces' README.md || fail "README missing disable command"
grep -q -F 'omarchy plugin enable jordan.workspaces' README.md || fail "README missing enable command"
grep -q -F 'preview.png' README.md || fail "README missing preview"
grep -q -F '## Usage' README.md || fail "README missing Usage"
grep -q -F '## Config' README.md || fail "README missing Config"
grep -q -F '## Requirements' README.md || fail "README missing Requirements"
grep -q -F '## 1.0.2' CHANGELOG.md || fail "CHANGELOG missing 1.0.2"
grep -q -F '## 1.0.1' CHANGELOG.md || fail "CHANGELOG missing 1.0.1"
grep -q -F '## 1.0.0' CHANGELOG.md || fail "CHANGELOG missing 1.0.0"

if grep -q -E 'bar\.run\(|clonedFrom|moduleName: "omarchy' BarWidget.qml; then
  fail "forbidden strings in BarWidget.qml"
fi
grep -q -F 'moduleName: "jordan.workspaces"' BarWidget.qml || fail "moduleName mismatch"
grep -q -F 'hl.dsp.focus({ workspace = ' BarWidget.qml || fail "lua focus dispatch missing"
if grep -q -F 'Hyprland.dispatch("workspace ' BarWidget.qml; then
  fail "legacy workspace dispatch"
fi
grep -q -F 'function pillText' BarWidget.qml || fail "pillText missing"
grep -q -F 'monitors.length <= 1' BarWidget.qml || fail "single-monitor tag"
grep -q -F 'ABCDEFGH' BarWidget.qml || fail "letter tags"

python3 - << 'PY' || fail "tree"
import pathlib
import re
import sys

roots = [
    pathlib.Path("README.md"),
    pathlib.Path("CHANGELOG.md"),
    pathlib.Path("BarWidget.qml"),
    pathlib.Path("manifest.json"),
    pathlib.Path("LICENSE"),
    pathlib.Path(".github/workflows/test.yml"),
]
banned = ("sudo", "pkexec")
placeholder = re.compile(r"\b(TODO|FIXME|lorem|TBD)\b", re.I)
problems = []
for path in roots:
    if not path.is_file():
        problems.append(f"missing {path}")
        continue
    text = path.read_text()
    if "\u2014" in text or "\u2013" in text:
        problems.append(f"em or en dash in {path}")
    for word in banned:
        if word in text:
            problems.append(f"{word} in {path}")
    if placeholder.search(text):
        problems.append(f"placeholder in {path}")
for path in pathlib.Path(".").rglob("*"):
    if ".git" in path.parts:
        continue
    if path.is_symlink():
        problems.append(f"symlink {path}")
if problems:
    print("\n".join(problems), file=sys.stderr)
    sys.exit(1)
PY

echo ok
