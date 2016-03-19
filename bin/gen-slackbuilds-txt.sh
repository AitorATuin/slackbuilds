#!/bin/sh

DEST_FILE=SLACKBUILDS.TXT

function upper() {
    echo $1 | tr '[:lower:]' '[:upper:]'
}

function line() {
    echo "SLACKBUILD $1: $2"
}

rm -rf ${DEST_FILE}

for pkg_info in $(find . -name "*.info"); do
    pkg_dir=`dirname ${pkg_info}`
    pkg_desc=${pkg_dir}/slack-desc
    pkg_info_basename=$(basename ${pkg_info})
    pkg_name=${pkg_info_basename%%.*}
    echo "Processing package ${pkg_name}"
    [ ! -f ${pkg_info} ] && {
        echo "Ignoring package ${pkg_name}. Missing ${pkg_info}"
        continue
    }
    [ ! -f ${pkg_desc} ] && {
        echo "Ignoring package ${pkg_name}. Missing ${pkg_desc}"
        continue
    }
    description=$(cat ${pkg_desc} | grep ${pkg_name} | head -1 |cut -d " " -f 3-)
    source ${pkg_info}
    [ "${PRGNAM}" != "${pkg_name}" ] && {
        echo "Ignoring package ${pkg_name}: PRGNAM ${PRGNAM} != ${pkg_name}"
        continue
    }
    line "NAME" ${PRGNAM} >> ${DEST_FILE}
    line "VERSION" ${VERSION} >> ${DEST_FILE}
    line "SHORT DESCRIPTION" "${PRGNAM} ${description}" >> ${DEST_FILE}
    echo "" >> ${DEST_FILE}
done
