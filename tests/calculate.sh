#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

cd $1

# bwaMem
#find . -xtype f -name "*.txt" -exec sh -c "wc -l {}" \;
#find . -xtype f -name "*.log" -exec sh -c "wc -l {}" \;

# bamQC
module load jq
# remove the Picard header because it includes temporary paths
find . -xtype f -name "*.json" -exec jq 'del(.picard | .header)' {} \; | python3 -mjson.tool --sort-keys

#fingerprintCollector
#find . -xtype f -name "*.fin" -execdir wc -l {} \; | sed 's/ .*//'
