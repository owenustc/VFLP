#!/bin/bash
# ---------------------------------------------------------------------------
#
# Usage: . exchange-continue-jobline first_VF_JOBLINE_NO last_VF_JOBLINE_NO job_template [quiet]
#
# Description: Exchange jobfiles and continue a jobline which was already started.
#
# Option: quiet (optional)
#    Possible values:
#        quiet: No information is displayed on the screen.
#
# Revision history:
# 2015-12-05  Created (version 1.2)
# 2015-12-12  Various improvements (version 1.10)
# 2015-12-16  Adaption to version 2.1
# 2016-07-16  Various improvements
#
# ---------------------------------------------------------------------------
# Displaying help if the first argument is -h
usage="Usage: . exchange-continue-jobline first_VF_JOBLINE_NO last_VF_JOBLINE_NO job_template [quiet]"
if [ "${1}" == "-h" ]; then
   echo -e "\n${usage}\n\n"
   exit 0
fi
if [[ "$#" -ne "3" && "$#" -ne "4" ]]; then
   echo -e "\nWrong number of arguments. Exiting."
   echo -e "\n${usage}\n\n"
   exit 1
fi

# Standard error response
error_response_nonstd() {
    echo "Error was trapped which is a nonstandard error."
    echo "Error in bash script $(basename ${BASH_SOURCE[0]})"
    echo "Error on line $1"
    exit 1
}
trap 'error_response_nonstd $LINENO' ERR

# Variables
i=0
first_VF_JOBLINE_NO=${1}
last_VF_JOBLINE_NO=${2}
job_template=${3}
if [ -z  "${4}" ]; then
    quiet_mode="off"
else
    quiet_mode=${4}
fi

# Continuing the jobline
for VF_JOBLINE_NO in $(seq ${first_VF_JOBLINE_NO} ${last_VF_JOBLINE_NO}); do
    i=$(( i + 1 ))
    . exchange-jobfile.sh ${job_template} ${VF_JOBLINE_NO} ${quiet_mode}
    . continue-jobline.sh ${VF_JOBLINE_NO} "sync"
done

# Displaying some information if no quiet option
if [[ ! "$*" = *"quiet"* ]]; then
    echo
    echo "Number of joblines which were continued: ${i}"
    echo
fi
