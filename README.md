# 🛡️ Browser Extensions Privacy Center & Hosting Hub
> **Official Public Privacy Policies and Compliance Disclosures for Browser Extensions by Sakhawat Hossain**

[![GitHub Pages](https://img.shields.io/badge/Hosting-GitHub_Pages-22c55e?style=for-the-badge&logo=github&logoColor=white)](https://sajusun.github.io/extensions/)
[![Manifest V3 Compliant](https://img.shields.io/badge/Compliance-Manifest_V3-3b82f6?style=for-the-badge&logo=googlechrome&logoColor=white)](https://developer.chrome.com/docs/extensions/mv3/)
[![Store Standards](https://img.shields.io/badge/Store_Ready-Edge_&_Chrome-6366f1?style=for-the-badge&logo=microsoftedge&logoColor=white)](https://microsoftedge.microsoft.com/addons)
[![Zero Tracking](https://img.shields.io/badge/Data_Ethics-100%25_Zero_Tracking-emerald?style=for-the-badge)](#-core-privacy-principles)

This repository contains the standalone, production-ready **Privacy Policy pages** for our suite of developer utilities, document tools, and productivity browser extensions. Each policy is engineered to meet and exceed the legal and certification requirements of the **Google Chrome Web Store**, **Microsoft Edge Add-ons Store**, and **Mozilla Add-ons (AMO)**.

---

## 📑 Live Policies Directory

| Extension Name | Version | Primary Purpose | Live Hosted Policy URL |
|---|---|---|---|
| **[DevFill](./devfill/privacy/index.html)** | `v1.0.1` | Smart Dummy Form Filler for Web Developers & QA | `https://sajusun.github.io/extensions/devfill/privacy/` |
| **[EchoScope](./echoscope/privacy/index.html)** | `v1.0.0` | Real-time WebSocket & Laravel Reverb Inspector | `https://sajusun.github.io/extensions/echoscope/privacy/` |
| **[EdgePDF SmartTools](./edgepdf/privacy/index.html)** | `v1.0.0` | 1-Click Table to Excel (.xlsx) & Client-Side OCR | `https://sajusun.github.io/extensions/edgepdf/privacy/` |
| **[LaraLens](./laralens/privacy/index.html)** | `v1.0.0` | Laravel CSRF, Cookie, Inertia & Ziggy DevTools | `https://sajusun.github.io/extensions/laralens/privacy/` |
| **[MapLeads Pro](./mapleads/privacy/index.html)** | `v1.0.0` | Google Maps Lead Scraper & B2B Spreadsheet Exporter | `https://sajusun.github.io/extensions/mapleads/privacy/` |
| **[OfficeMate for Edge](./officemate/privacy/index.html)** | `v1.0.0` | Outlook AI Drafts, Teams Notes & Workspace Tab Stash | `https://sajusun.github.io/extensions/officemate/privacy/` |
| **[PureEdge CleanTab](./pureedge/privacy/index.html)** | `v1.0.0` | Purge MSN Clickbaits & Minimalist 4K NewTab | `https://sajusun.github.io/extensions/pureedge/privacy/` |
| **[SnapSnippet](./snapsnippet/privacy/index.html)** | `v1.0.0` | Developer Command Clipboard & Spotlight Command Bar | `https://sajusun.github.io/extensions/snapsnippet/privacy/` |

---

## 🏛️ Directory Architecture

The repository follows the canonical trailing-slash URL hierarchy (`<project>/privacy/index.html`), allowing GitHub Pages to automatically route requests to clean URLs without requiring `.html` extensions.

```text
extensions/ (GitHub Pages root)
│
├── index.html                               # Global Privacy Portal (Hub linking to all policies)
├── README.md                                # Repository guide and store submission mapping
│
├── devfill/
│   └── privacy/
│       └── index.html                       # DevFill Privacy Policy
│
├── echoscope/
│   └── privacy/
│       └── index.html                       # EchoScope Privacy Policy
│
├── edgepdf/
│   └── privacy/
│       └── index.html                       # EdgePDF SmartTools Privacy Policy
│
├── laralens/
│   └── privacy/
│       └── index.html                       # LaraLens Privacy Policy
│
├── mapleads/
│   └── privacy/
│       └── index.html                       # MapLeads Pro Privacy Policy
│
├── officemate/
│   └── privacy/
│       └── index.html                       # OfficeMate for Edge Privacy Policy
│
├── pureedge/
│   └── privacy/
│       └── index.html                       # PureEdge CleanTab Privacy Policy
│
└── snapsnippet/
    └── privacy/
        └── index.html                       # SnapSnippet Privacy Policy
```

---

## 🔒 Core Privacy Principles Across All Extensions

Every browser extension in this suite is built around four uncompromising foundational pillars:

1. **Zero Unsolicited Telemetry:** No user activity, keystrokes, form submissions, or browsing history are ever logged, tracked, or sold to third parties or data brokers.
2. **Local Sandbox Storage:** All user configurations, preferences, and cached records are stored strictly in the browser's native client-side storage (`chrome.storage.local`).
3. **No Remote Code Execution:** Strictly compliant with Manifest V3 policies. Zero dynamic `eval()`, zero external CDN scripts, and zero remote code injection.
4. **Least Privilege Principle:** Every browser permission declared in `manifest.json` is justified in a dedicated permissions matrix table detailing exact operational necessity.

---

## 🎨 Design System & Page Features

All HTML policy documents are self-contained and feature a unified, responsive design system:

- **Typography:** Modern typography stack with Google Fonts [`Plus Jakarta Sans`](https://fonts.google.com/specimen/Plus+Jakarta+Sans) and [`JetBrains Mono`](https://fonts.google.com/specimen/JetBrains+Mono) for technical codes/identifiers.
- **Brand Theming:** Dedicated color palettes matching each extension (Emerald for DevFill, Violet for EchoScope, Crimson for EdgePDF, Laravel Red for LaraLens, Blue for MapLeads, Azure for OfficeMate, Teal for PureEdge, Indigo for SnapSnippet).
- **Interactive Quick-Navigation:** Sticky header bar, 4-point highlight cards, and an interactive Table of Contents (TOC) linking directly to numbered policy sections.
- **Regulatory Disclosures:**
  - European General Data Protection Regulation (**GDPR**)
  - California Consumer Privacy Act (**CCPA / CPRA**)
  - Children's Online Privacy Protection Act (**COPPA**)
  - Complete Browser Permissions Justification matrix
- **Zero External Dependencies:** Built with vanilla HTML & CSS in a single file per policy for lightning-fast loading speeds and 100% offline readability.

---

## 🚀 Deployment on GitHub Pages

The repository is hosted at [github.com/sajusun/extensions](https://github.com/sajusun/extensions) and published via GitHub Pages:

1. Push your changes to the `main` branch:
   ```bash
   git add .
   git commit -m "feat: add landing pages and privacy policies"
   git push origin main
   ```
2. In your GitHub repository **Settings** &rarr; **Pages**:
   - **Source:** Deploy from a branch
   - **Branch:** `main` / `/(root)`
3. The site is live at:
   ```text
   https://sajusun.github.io/extensions/
   ```

---

## 🏪 Store Submission Guide

When submitting your extension package to developer portals:

### 1. Microsoft Edge Add-ons (Partner Center)
- In the **Store Listings** tab:
  - **Homepage URL:** `https://sajusun.github.io/extensions/<project>/`
  - **Privacy Policy URL:** `https://sajusun.github.io/extensions/<project>/privacy/`
- In **Certification Notes**, note that all processing is 100% client-side with zero telemetry.

### 2. Google Chrome Web Store Developer Dashboard
- In the **Store Listing** tab:
  - **Homepage URL:** `https://sajusun.github.io/extensions/<project>/`
- In the **Privacy** tab:
  - **Privacy policy URL:** `https://sajusun.github.io/extensions/<project>/privacy/`
  - Check the declaration certifying that user data is not sold or transferred.
  - Under **Permissions justification**, refer to Section 04 of the corresponding policy page.

---

## 👤 Developer & Maintainer

**Sakhawat Hossain**
- 🌐 **Portfolio & Website:** [https://sajusun.github.io](https://sajusun.github.io)
- 🐙 **GitHub:** [@sajusun](https://github.com/sajusun)
- 💼 **Focus:** Full-Stack Web Development, Developer Tools & Browser Extensions

---

## 📄 License
The template structure and privacy documentations are provided under the [MIT License](https://opensource.org/licenses/MIT).

