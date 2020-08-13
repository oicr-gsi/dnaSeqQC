#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

cd $1

# bwaMem
find . -type f -name "*.txt" -exec sh -c "wc -l {}" \;
find . -type f -name "*.log" -exec sh -c "wc -l {}" \;

# bamQC
module load jq
module load python/3.6
# remove the Picard header because it includes temporary paths
find . -type f -name "*.json" -exec jq 'del(.picard | .header)' {} \; | python3 -mjson.tool --sort-keys

