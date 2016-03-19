#!/bin/sh

DEST_FILE=SLACKBUILDS.TXT

function upper() {
    echo $1 | tr '[:lower:]' '[:upper:]'
}

function line() {
    echo "SLACKBUILD $1: $2"
}

function error() {
    echo "ERROR: $1: $2"
}

rm -rf ${DEST_FILE}

for pkg_info in $(find . -name "*.info"); do
    pkg_dir=`dirname ${pkg_info}`
    pkg_section=${pkg_dir##/*}
    pkg_desc=${pkg_dir}/slack-desc
    pkg_info_basename=$(basename ${pkg_info})
    pkg_name=${pkg_info_basename%%.*}
    echo "Processing package ${pkg_name}"
    [ ! -f ${pkg_info} ] && {
        error ${pkg_section} "Missing ${pkg_info}"
        continue
    }
    [ ! -f ${pkg_desc} ] && {
        error ${pkg_section} "Missing ${pkg_desc}"
        continue
    }
    lines_in_desc=$(cat ${pkg_desc} | grep ${pkg_name} | wc -l)
    [ ${lines_in_desc} -ne 11 ] && {
        error ${pkg_section} "slack-desc must contain 11 lines in the description"
        continue
    }
    description=$(cat ${pkg_desc} | grep ${pkg_name} | head -1 |cut -d " " -f 3-)
    source ${pkg_info}
    [ "${PRGNAM}" != "${pkg_name}" ] && {
        error ${pkg_section} "PRGNAM ${PRGNAM} != ${pkg_name}"
        continue
    }
    line "NAME" ${PRGNAM} >> ${DEST_FILE}
    line "VERSION" ${VERSION} >> ${DEST_FILE}
    line "SHORT DESCRIPTION" "${PRGNAM} ${description}" >> ${DEST_FILE}
    echo "" >> ${DEST_FILE}
done
