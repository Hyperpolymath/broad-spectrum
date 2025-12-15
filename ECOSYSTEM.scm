;; SPDX-License-Identifier: AGPL-3.0-or-later
;; SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell
;; ECOSYSTEM.scm — broad-spectrum

(ecosystem
  (version "1.0.0")
  (name "broad-spectrum")
  (type "project")
  (purpose "A comprehensive CLI website auditor built with ReScript, Deno, and TypeScript. Performs automated security, accessibility, performance, and SEO audits on websites.")

  (position-in-ecosystem
    "Part of hyperpolymath ecosystem. Follows RSR guidelines.")

  (related-projects
    (project (name "rhodium-standard-repositories")
             (url "https://github.com/hyperpolymath/rhodium-standard-repositories")
             (relationship "standard")))

  (what-this-is "A comprehensive CLI website auditor built with ReScript, Deno, and TypeScript. Performs automated security, accessibility, performance, and SEO audits on websites.")
  (what-this-is-not "- NOT exempt from RSR compliance"))
