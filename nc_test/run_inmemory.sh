#!/bin/sh


if test "x$srcdir" = x ; then srcdir=`pwd`; fi
. ../test_common.sh

set -e

# Get the target OS and CPU
CPU=`uname -p`
OS=`uname`

#Constants
FILE3=tst_inmemory3
CREATE3=tst_inmemory3_create
FILE4=tst_inmemory4
CREATE4=tst_inmemory4_create

# For tst_open_mem
OMEMFILE=f03tst_open_mem.nc

CHECKERR() {

    RES=$?

        if [[ $RES -ne 0 ]]; then
        echo "Error Caught: $RES"
        exit $RES
    fi

}

echo ""
echo "*** Testing in-memory operations"

HASNC4=`${top_builddir}/nc-config --has-nc4`

# Execute the core of the inmemory tests
if ! ${execdir}/tst_inmemory; then
   echo "FAIL: tst.inmemory"
fi
if ! ${execdir}/tst_open_mem ${srcdir}/${OMEMFILE}; then
   echo "FAIL: tst_open_mem"
fi

echo "**** Test ncdump of the resulting inmemory data"
${NCDUMP} -n "${FILE3}" ${FILE3}.nc > ${FILE3}.cdl ; CHECKERR
${NCDUMP} -n "${FILE3}" ${CREATE3}.nc > ${CREATE3}.cdl ; CHECKERR
if ! diff -wb ${FILE3}.cdl ${CREATE3}.cdl ; then
   echo "FAIL: ${FILE3}.cdl vs ${CREATE3}.cdl"
fi

if test "x$HASNC4" = "xyes" ; then
${NCDUMP} ${FILE4}.nc > ${FILE4}.cdl ; CHECKERR
${NCDUMP} ${CREATE4}.nc > ${CREATE4}.cdl ; CHECKERR
if diff -wb ${FILE4}.cdl ${CREATE4}.cdl ; then
   echo "FAIL: ${FILE4}.cdl vs ${CREATE4}.cdl"
fi

# cleanup
rm -f ${FILE3}.nc ${FILE4}.nc ${CREATE3}.nc ${CREATE4}.nc
rm -f ${FILE3}.cdl ${FILE4}.cdl ${CREATE3}.cdl ${CREATE4}.cdl

echo "PASS: all inmemory tests"

exit 0
