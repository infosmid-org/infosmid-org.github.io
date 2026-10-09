# infosmid.org

The official landing page and open-source portal for [infosmid.org](https://infosmid.org), hosting open-source software, developer tools, and cloud-native architecture solutions created and maintained by [infosmid.com](https://infosmid.com).

## Overview

This project is deployed using [GitHub Pages](https://pages.github.com/) under the custom domain `infosmid.org`.

Key design principles:
- **Maximum Utility & Performance:** Zero runtime framework bloat, fast load times, and self-contained styling.
- **Brand Consistency:** Designed around the primary brand color (`#374a5a`) and typography derived from `brand/infosmid-org.svg`.
- **Accessibility & Responsiveness:** Clean semantic HTML5, WCAG AAA contrast ratio compliance, keyboard navigation, and dark mode support via `prefers-color-scheme`.

## Project Structure

```
├── CNAME                              # GitHub Pages custom domain configuration (infosmid.org)
├── .nojekyll                          # Disables Jekyll processing for raw static serving
├── index.html                         # Semantic HTML5 landing page
├── css/
│   └── style.css                      # Brand styling, responsive layout, and theme variables
├── brand/
│   ├── infosmid-org.svg               # Vector brand graphic with white background
│   └── infosmid-org-transparent.svg   # Vector brand graphic with transparent background
└── README.md                          # Project documentation
```

## Local Development & Preview

To preview the landing page locally without external dependencies:

```bash
# Python 3 built-in HTTP server
python3 -m http.server 8000
```

Then navigate to `http://localhost:8000` in your web browser.

## Deployment

Pushes to the `main` branch are automatically served by GitHub Pages when GitHub Pages is configured to publish from the repository root (`/`). The `CNAME` file ensures proper DNS and TLS certificate management for `infosmid.org`.
