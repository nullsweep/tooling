#!/bin/bash

## usage: ./nmap_html.sh <target> [output_filename]

if [ -z "$1" ]; then
  echo "Usage: $0 <target> [output_filename]"
  exit 1
fi

TARGET="$1"
FILENAME="$2"

if [ -z "$FILENAME" ]; then
  TIMESTAMP=$(date +%Y%m%d_%H%M%S)
  FILENAME="scan_${TARGET//[^a-zA-Z0-9]/_}_$TIMESTAMP.html"
fi

XSL_PATH="/usr/share/nmap/nmap.xsl"
if [ ! -f "$XSL_PATH" ]; then
  echo "Error: Nmap stylesheet not found at $XSL_PATH"
  exit 2
fi

echo "[*] Scanning $TARGET..."
nmap -sV -oX - "$TARGET" | xsltproc "$XSL_PATH" - > "$FILENAME"

if [ $? -eq 0 ]; then
  echo "[+] Scan complete. Report saved as $FILENAME"
else
  echo "[-] Something went wrong during scanning or conversion."
  exit 3
fi
