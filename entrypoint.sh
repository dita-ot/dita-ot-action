#! /bin/sh

# This file is part of the DITA-OT Build GitHub Action project.
# See the accompanying LICENSE file for applicable licenses.

set -e

TRANSTYPE="${1}"
INPUT="${2:-document.ditamap}"
OUTPUT_PATH="${3:-out}"
PROPERTIES="${4}"
PLUGINS="${5}"
INSTALL_SCRIPT="${6}"
INSTALL_FILE=/github/workspace/${INSTALL_SCRIPT}
BUILD_SCRIPT="${7}"
BUILD_FILE=/github/workspace/${BUILD_SCRIPT}
DITA_OT_VERSION="${8}"


if [ ! -z "${DITA_OT_VERSION}" ]; then 
	echo "[INFO] Installing DITA-OT ${DITA_OT_VERSION}"
	rm -rf  /opt/app
	mkdir /opt/app

	curl -sLo /tmp/dita-ot-"${DITA_OT_VERSION}".zip https://github.com/dita-ot/dita-ot/releases/download/"${DITA_OT_VERSION}"/dita-ot-"${DITA_OT_VERSION}".zip
    unzip -qq /tmp/dita-ot-"${DITA_OT_VERSION}".zip -d /tmp/
    rm /tmp/dita-ot-"${DITA_OT_VERSION}".zip
    mkdir -p /opt/app/
    mv /tmp/dita-ot-"${DITA_OT_VERSION}"/bin /opt/app/bin
    chmod 755 /opt/app/bin/dita
    mv /tmp/dita-ot-"${DITA_OT_VERSION}"/config /opt/app/config
    mv /tmp/dita-ot-"${DITA_OT_VERSION}"/lib /opt/app/lib
    mv /tmp/dita-ot-"${DITA_OT_VERSION}"/plugins /opt/app/plugins
    mv /tmp/dita-ot-"${DITA_OT_VERSION}"/build.xml /opt/app/build.xml
    mv /tmp/dita-ot-"${DITA_OT_VERSION}"/integrator.xml /opt/app/integrator.xml
    rm -r /tmp/dita-ot-"${DITA_OT_VERSION}"
	dita --install
fi

if [ -d /github/workspace/ ]; then
	cd /github/workspace/
fi
echo "[INFO]" $(dita --version)

if [ ! -z "${PLUGINS}" ]; then 
	echo "[INFO] Installing prequisite DITA-OT plugins"
	list=$(echo "$PLUGINS" | tr "," "\n")
	for prereq in $list
	do
		dita install "$prereq"
	done
fi

if [ -f "$INSTALL_FILE" ]; then
	echo "[INFO] Running install script"
	"${INSTALL_FILE}"
elif [ ! -z "${INSTALL_SCRIPT}" ]; then
	echo "[INFO] Installing using command-line" 
	echo "${INSTALL_SCRIPT}" >> /install_script.sh
	exec /install_script.sh
fi	

if [ ! -z "${TRANSTYPE}" ]; then
	echo "[INFO] Running ${TRANSTYPE} build"  
	dita -i "${INPUT}" -o "${OUTPUT_PATH}/${TRANSTYPE}"  -f "${TRANSTYPE}" "${PROPERTIES}"
elif [ -f "$BUILD_FILE" ]; then
	echo "[INFO] Running build script"
	"${BUILD_FILE}"
elif [ ! -z "${BUILD_SCRIPT}" ]; then
	echo "[INFO] building using command-line"
	echo "${BUILD_SCRIPT}" >> /build_script.sh
	exec /build_script.sh
else
	echo "[INFO] Running PDF build" 
	dita -i "${INPUT}" -o "${OUTPUT_PATH}/pdf"  -f pdf "${PROPERTIES}"
fi	
