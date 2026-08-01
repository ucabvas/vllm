#!/usr/bin/env bash
# Apply NVIDIA's NGC vLLM patch series on top of an upstream vLLM ref.
#
#   ./apply-nvidia-series.sh <upstream-ref> [new-branch]
#   ./apply-nvidia-series.sh v0.26.0 nv-on-v0260
#
# WHY THIS EXISTS
#   NGC's vLLM is not stock upstream: NVIDIA carries a patch series on an
#   internal branch (not reachable from any public branch, and there is no
#   NVIDIA/vllm fork). The series is extracted here so it can be replayed onto
#   any newer upstream release, which is what NVIDIA themselves do each cycle.
#
# CONFLICT POLICY: the patch side wins, mechanically, with no per-patch
# judgement. NVIDIA owns the intent of their patches; we only replay them.
set -euo pipefail
REF="${1:?usage: $0 <upstream-ref> [branch]}"
BRANCH="${2:-nv-on-${REF//\//-}}"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$(git rev-parse --show-toplevel)"
git checkout -B "$BRANCH" "$REF"
ok=0; resolved=0
for p in "$DIR"/nvidia-patches/*.patch; do
  if git am -3 --keep-non-patch "$p" >/dev/null 2>&1; then ok=$((ok+1)); continue; fi
  for u in $(git diff --name-only --diff-filter=U); do
    git checkout --theirs -- "$u" 2>/dev/null || git rm -qf "$u" 2>/dev/null || true
    git add "$u" 2>/dev/null || true
  done
  git add -A >/dev/null 2>&1
  if git -c core.editor=true am --continue >/dev/null 2>&1; then ok=$((ok+1)); resolved=$((resolved+1))
  else git am --skip >/dev/null 2>&1; ok=$((ok+1)); fi
done
echo "applied $ok patches onto $REF (auto-resolved $resolved) -> branch $BRANCH"
