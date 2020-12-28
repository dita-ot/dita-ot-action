#! /bin/sh

# This file is part of the DITA-OT Build GitHub Action project.
# See the accompanying LICENSE file for applicable licenses.

set -e

DITA_OT_VERSION="${1:-3.6}"
PLUGINS="${2}"
SETUP_SCRIPT="${3:-setup.sh}"
FILE=/github/workspace/${SETUP_SCRIPT}
DITAMAP="${4:-document.ditamap}"
TRANSTYPES="${5:-pdf}"
PROPERTIES="${6}"
OUTPUT_PATH="${7:-out}"

cd /opt/app/bin/
curl -sLO https://github.com/dita-ot/dita-ot/releases/download/"${DITA_OT_VERSION}"/dita-ot-"${DITA_OT_VERSION}".zip
unzip -q dita-ot-"${DITA_OT_VERSION}".zip
rm dita-ot-"${DITA_OT_VERSION}".zip
chmod 755 dita-ot-"${DITA_OT_VERSION}"/bin/dita

PATH="${PATH}":/opt/app/bin/dita-ot-"${DITA_OT_VERSION}"/bin

echo "[INFO] Installing DITA-OT"
dita --install

if [ -f "$FILE" ]; then
	echo "[INFO] Installing additional runtime dependencies"
	"${FILE}"
fi

if [ ! -z "${PLUGINS}" ]; then 
	echo "[INFO] Installing prequisite DITA-OT plugins"
	list=$(echo "$PLUGINS" | tr "," "\n")
	for prereq in $list
	do
		dita install "$prereq"
	done
fi

transtypeList=$(echo "${TRANSTYPES}" | tr "," "\n")
for transtype in $transtypeList
do
	echo "[INFO] Building ${transtype}"
	dita -i "${DITAMAP}" -f "${transtype}" -o "${OUTPUT_PATH}"/"${transtype}" "${PROPERTIES}"
done
