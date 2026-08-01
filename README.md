# NVIDIA NGC vLLM patch series

The 31 commits NVIDIA carries on top of upstream vLLM in
`nvcr.io/nvidia/vllm:26.07-py3`, extracted so they can be replayed onto newer
upstream releases.

## Provenance

Tip commit `092c4842e49a` (`vllm-0.24.0+092c4842.nv26.7`), authored by
`scastagnetta@nvidia.com`. Walking its first-parent chain reaches upstream
`ee0da84ab` (2026-06-28) after 31 commits, by 12 NVIDIA authors.

Neither the tip nor any of its 31 ancestors is reachable from any of the 356
branches of `vllm-project/vllm`, and no `NVIDIA/vllm` fork exists -- NVIDIA
builds from an internal branch, rebasing it onto newer upstream periodically
(author dates run 2026-05..06 while committer dates cluster at 2026-07-09).
The series is therefore reconstructed from the GitHub commit API, not fetched.

## Usage

    ./apply-nvidia-series.sh v0.26.0

## Conflict policy

The patch side wins, mechanically. We do not second-guess NVIDIA's intent
patch by patch -- that is their job. Applied onto v0.26.0: 31 applied,
5 auto-resolved, 26 non-empty commits.
