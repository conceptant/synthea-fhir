#!/bin/sh

cd /synthea
if [ ${SYNTHEA_SEED} ]; then
    ./run_synthea -s ${SYNTHEA_SEED} -p ${SYNTHEA_SIZE}
else
    ./run_synthea -p ${SYNTHEA_SIZE}
fi

if [ ${FHIR_URL} ]; then
    cd /uploader
    ./uploader -path=/synthea/output/fhir -fhir="${FHIR_URL}"
fi