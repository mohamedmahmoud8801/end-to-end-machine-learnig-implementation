#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MERMAID_DIR="${SCRIPT_DIR}/mermaid"
OUTPUT_DIR="${SCRIPT_DIR}/diagrams"
PUPPETEER_CONFIG="${SCRIPT_DIR}/puppeteer-config.json"

print_install_instructions() {
    cat <<'EOF'
Mermaid CLI (mmdc) was not found on PATH.

Install Mermaid CLI:

Ubuntu / Debian:
  sudo apt update
  sudo apt install -y nodejs npm
  sudo npm install -g @mermaid-js/mermaid-cli
  mmdc --version

macOS:
  brew install node
  npm install -g @mermaid-js/mermaid-cli
  mmdc --version

Windows:
  1. Install Node.js LTS from https://nodejs.org/
  2. Open PowerShell or Command Prompt.
  3. Run:
       npm install -g @mermaid-js/mermaid-cli
       mmdc --version

If PNG or PDF export fails on Linux because Chromium dependencies are missing,
install them with:
  sudo apt install -y chromium-browser

EOF
}

if ! command -v mmdc >/dev/null 2>&1; then
    print_install_instructions
    exit 127
fi

if [ ! -d "${MERMAID_DIR}" ]; then
    echo "Mermaid source directory not found: ${MERMAID_DIR}" >&2
    exit 1
fi

shopt -s nullglob
MMD_FILES=("${MERMAID_DIR}"/*.mmd)

if [ "${#MMD_FILES[@]}" -eq 0 ]; then
    echo "No Mermaid source files found in ${MERMAID_DIR}" >&2
    exit 1
fi

mkdir -p "${OUTPUT_DIR}"

for source_file in "${MMD_FILES[@]}"; do
    diagram_name="$(basename "${source_file}" .mmd)"

    echo "Rendering ${diagram_name}"
    mmdc -p "${PUPPETEER_CONFIG}" -i "${source_file}" -o "${OUTPUT_DIR}/${diagram_name}.svg"
    mmdc -p "${PUPPETEER_CONFIG}" -i "${source_file}" -o "${OUTPUT_DIR}/${diagram_name}.png"
    mmdc -p "${PUPPETEER_CONFIG}" -i "${source_file}" -o "${OUTPUT_DIR}/${diagram_name}.pdf"
done

echo "Generated diagrams in ${OUTPUT_DIR}"
