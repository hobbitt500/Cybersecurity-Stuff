#!/bin/bash
# Website Downloader for Cybersecurity Reconnaissance
#
# This script recursively downloads a website and replicates its directory structure.
# It’s useful for gathering an offline copy of a site to speed up directory analysis.
#
# Usage: ./Fastestdirsearch.sh <target_url> [recursion_depth]
#
# Example:
#   ./Fastestdirsearch.sh http://example.com 5
#
# DISCLAIMER: Use this script only on websites/servers you have permission to test.

# Check if wget is installed
if ! command -v wget &> /dev/null; then
    echo "[ERROR] wget is not installed. Please install wget and try again."
    exit 1
fi

# Validate input parameters
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <target_url> [recursion_depth]"
    exit 1
fi

TARGET="$1"
# If a recursion depth is provided, use it; otherwise, default to 5
if [ "$#" -ge 2 ]; then
    LEVEL="$2"
else
    LEVEL=5
fi

# Generate an output directory name based on the target domain/IP
OUTPUT_DIR=$(echo "$TARGET" | awk -F[/:] '{print $4}')
if [ -z "$OUTPUT_DIR" ]; then
    OUTPUT_DIR="downloaded_site"
fi
mkdir -p "$OUTPUT_DIR"

echo "[INFO] Starting recursive download of: $TARGET"
echo "[INFO] Recursion depth set to: $LEVEL"
echo "[INFO] Files will be saved to: $OUTPUT_DIR"

# Execute wget with several options:
#   --recursive            : Enable recursive downloading.
#   --level=<LEVEL>        : Limit the recursion to a certain depth.
#   --no-parent            : Do not ascend to the parent directory.
#   --wait=1 & --random-wait: Polite delays between requests.
#   --adjust-extension    : Save files with the appropriate extensions.
#   --convert-links       : Convert links for local viewing.
#   --page-requisites     : Download all assets (CSS, JS, images) needed to display pages.
#   --no-check-certificate: Ignore SSL certificate errors.
#   --timeout=10          : Set a network timeout.
#   --tries=3             : Retry a few times on failures.
#   --directory-prefix    : Save files into the specified directory.
wget --recursive \
     --level="$LEVEL" \
     --no-parent \
     --wait=1 \
     --random-wait \
     --adjust-extension \
     --convert-links \
     --page-requisites \
     --no-check-certificate \
     --timeout=10 \
     --tries=3 \
     --directory-prefix="$OUTPUT_DIR" \
     "$TARGET"

echo "[INFO] Download complete. Check the '$OUTPUT_DIR' directory for the mirrored site."
