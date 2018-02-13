#!/bin/bash

echo "Running job_script_p4500p.sh"
date

. /lustre/nyx/hades/user/rlalik/hades/pp45/profile.sh

echo file=$pattern
echo events=$events
echo odir=$odir

root -b -q

cd /lustre/nyx/hades/user/rlalik/hades/pp45/sim/geant

card_file=/tmp/geaini_p4500p_fwdet__$(basename ${pattern} .evt).ini

date

# update placeholders and generate temporary file
sed \
    -e "s|@input@|${pattern}|" \
    -e "s|@output@|${odir}/$(basename ${pattern} .evt)_.root|" \
    simul_p4500p_fwdet.dat > ${card_file}

if [ -z ${HGEANT_DIR} ]; then
    time hgeant -b -c -f ${card_file}
else
    time ${HGEANT_DIR}/hgeant -b -c -f ${card_file}
fi

rm -fv ${card_file}
