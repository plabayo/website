#!/usr/bin/env bash
set -x
set -eo pipefail

sh -c 'cd plabayo-worker && npm i wrangler && npx wrangler publish'
