# Diagram Generation

This folder contains the HLD and extracted Mermaid diagram sources.

## Layout

```text
docs/
  HLD.md
  README.md
  generate_diagrams.sh
  puppeteer-config.json
  mermaid/
    architecture.mmd
    prediction_flow.mmd
    system_context.mmd
    training_flow.mmd
  diagrams/
    *.svg
    *.png
    *.pdf
```

## Install Mermaid CLI

Ubuntu / Debian:

```bash
sudo apt update
sudo apt install -y nodejs npm
sudo npm install -g @mermaid-js/mermaid-cli
mmdc --version
```

macOS:

```bash
brew install node
npm install -g @mermaid-js/mermaid-cli
mmdc --version
```

Windows:

```powershell
npm install -g @mermaid-js/mermaid-cli
mmdc --version
```

If PNG or PDF export fails on Linux because Chromium dependencies are missing, install Chromium:

```bash
sudo apt install -y chromium-browser
```

This project includes `puppeteer-config.json`, which passes Chromium's no-sandbox flags for restricted Linux environments.

## Generate Diagrams

From this directory:

```bash
./generate_diagrams.sh
```

From the project root:

```bash
docs/generate_diagrams.sh
```

The script renders every `.mmd` file in `docs/mermaid/` to SVG, PNG, and PDF under `docs/diagrams/`.

## Regenerate After Editing HLD.md

1. Edit the Mermaid block in `docs/HLD.md`.
2. Copy the updated Mermaid code block into the matching file under `docs/mermaid/`.
3. Run:

```bash
docs/generate_diagrams.sh
```

The script is idempotent and can be run multiple times. Existing generated SVG, PNG, and PDF files with the same names are overwritten by Mermaid CLI.
