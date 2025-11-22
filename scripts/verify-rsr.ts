#!/usr/bin/env -S deno run --allow-read

/**
 * RSR Compliance Verification Script
 *
 * Verifies that the repository complies with the Rhodium Standard Repository (RSR) framework.
 * Based on the RSR specification from the rhodium-minimal example.
 */

interface CheckResult {
  name: string;
  passed: boolean;
  message: string;
  category: string;
}

const results: CheckResult[] = [];

function check(category: string, name: string, condition: boolean, message: string): void {
  results.push({
    name,
    passed: condition,
    message,
    category,
  });
}

async function fileExists(path: string): Promise<boolean> {
  try {
    await Deno.stat(path);
    return true;
  } catch {
    return false;
  }
}

async function fileContains(path: string, text: string): Promise<boolean> {
  try {
    const content = await Deno.readTextFile(path);
    return content.includes(text);
  } catch {
    return false;
  }
}

console.log("RSR Compliance Verification");
console.log("===========================\n");

// Category 1: Documentation
console.log("Checking Documentation...");
check(
  "Documentation",
  "README.md",
  await fileExists("README.md"),
  "README.md must exist and contain project description"
);

check(
  "Documentation",
  "LICENSE",
  await fileExists("LICENSE"),
  "LICENSE file must exist with clear license terms"
);

check(
  "Documentation",
  "SECURITY.md",
  await fileExists("SECURITY.md"),
  "SECURITY.md must exist with vulnerability reporting process"
);

check(
  "Documentation",
  "CONTRIBUTING.md",
  await fileExists("CONTRIBUTING.md"),
  "CONTRIBUTING.md must exist with contribution guidelines"
);

check(
  "Documentation",
  "CODE_OF_CONDUCT.md",
  await fileExists("CODE_OF_CONDUCT.md"),
  "CODE_OF_CONDUCT.md must exist with community standards"
);

check(
  "Documentation",
  "MAINTAINERS.md",
  await fileExists("MAINTAINERS.md"),
  "MAINTAINERS.md must exist listing project maintainers"
);

check(
  "Documentation",
  "CHANGELOG.md",
  await fileExists("CHANGELOG.md"),
  "CHANGELOG.md must exist with version history"
);

check(
  "Documentation",
  "ARCHITECTURE.md",
  await fileExists("ARCHITECTURE.md"),
  "ARCHITECTURE.md should exist with design documentation"
);

// Category 2: .well-known Directory
console.log("Checking .well-known Directory...");
check(
  ".well-known",
  "security.txt",
  await fileExists(".well-known/security.txt"),
  "security.txt must exist per RFC 9116"
);

check(
  ".well-known",
  "ai.txt",
  await fileExists(".well-known/ai.txt"),
  "ai.txt must exist with AI training policies"
);

check(
  ".well-known",
  "humans.txt",
  await fileExists(".well-known/humans.txt"),
  "humans.txt must exist with attribution"
);

// Verify security.txt RFC 9116 compliance
const hasContact = await fileContains(".well-known/security.txt", "Contact:");
const hasExpires = await fileContains(".well-known/security.txt", "Expires:");
check(
  ".well-known",
  "security.txt RFC 9116",
  hasContact && hasExpires,
  "security.txt must have Contact: and Expires: fields"
);

// Category 3: Build System
console.log("Checking Build System...");
check(
  "Build System",
  "package.json",
  await fileExists("package.json"),
  "package.json must exist with dependencies"
);

check(
  "Build System",
  "rescript.json",
  await fileExists("rescript.json"),
  "rescript.json must exist for ReScript configuration"
);

check(
  "Build System",
  "deno.json",
  await fileExists("deno.json"),
  "deno.json must exist for Deno configuration"
);

check(
  "Build System",
  "justfile",
  await fileExists("justfile"),
  "justfile must exist with task definitions"
);

check(
  "Build System",
  "flake.nix",
  await fileExists("flake.nix"),
  "flake.nix must exist for Nix reproducible builds"
);

// Category 4: CI/CD
console.log("Checking CI/CD...");
const hasCIWorkflow = await fileExists(".github/workflows/ci.yml") ||
                       await fileExists(".gitlab-ci.yml") ||
                       await fileExists(".circleci/config.yml");
check(
  "CI/CD",
  "CI Configuration",
  hasCIWorkflow,
  "CI/CD configuration must exist (GitHub Actions, GitLab CI, or Circle CI)"
);

// Category 5: Testing
console.log("Checking Testing Infrastructure...");
const hasTests = await fileExists("tests/") ||
                  await fileExists("test/") ||
                  await fileExists("__tests__/");
check(
  "Testing",
  "Test Directory",
  hasTests,
  "Test directory must exist with test files"
);

// Category 6: Type Safety
console.log("Checking Type Safety...");
check(
  "Type Safety",
  "ReScript Configuration",
  await fileExists("rescript.json"),
  "ReScript provides compile-time type safety"
);

check(
  "Type Safety",
  "TypeScript Configuration",
  await fileExists("deno.json"),
  "Deno provides TypeScript type checking"
);

// Category 7: TPCF (Tri-Perimeter Contribution Framework)
console.log("Checking TPCF Compliance...");
const hasTPCF = await fileContains("CODE_OF_CONDUCT.md", "Perimeter") ||
                 await fileContains("CODE_OF_CONDUCT.md", "TPCF");
check(
  "TPCF",
  "TPCF Documentation",
  hasTPCF,
  "CODE_OF_CONDUCT.md must document TPCF perimeter model"
);

// Category 8: Source Code Organization
console.log("Checking Source Code...");
check(
  "Source Code",
  "src/ Directory",
  await fileExists("src/"),
  "Source code must be in src/ directory"
);

const hasMainEntry = await fileExists("src/main.ts") ||
                      await fileExists("src/index.ts") ||
                      await fileExists("src/Auditor.res");
check(
  "Source Code",
  "Entry Point",
  hasMainEntry,
  "Must have a clear entry point (main.ts, index.ts, or Auditor.res)"
);

// Category 9: Git Configuration
console.log("Checking Git Configuration...");
check(
  "Git",
  ".gitignore",
  await fileExists(".gitignore"),
  ".gitignore must exist to exclude build artifacts"
);

// Check that .gitignore excludes common artifacts
const gitignoreExcludes = await fileContains(".gitignore", "node_modules") &&
                           await fileContains(".gitignore", "lib");
check(
  "Git",
  ".gitignore Content",
  gitignoreExcludes,
  ".gitignore must exclude node_modules/ and lib/"
);

// Category 10: Examples (Optional but Recommended)
console.log("Checking Examples...");
const hasExamples = await fileExists("examples/") ||
                     await fileExists("example/");
check(
  "Examples",
  "Examples Directory",
  hasExamples,
  "Examples directory should exist with usage examples"
);

// Print Results
console.log("\n" + "=".repeat(70));
console.log("RESULTS");
console.log("=".repeat(70) + "\n");

const categories = new Set(results.map(r => r.category));
let totalPassed = 0;
let totalFailed = 0;

for (const category of categories) {
  const categoryResults = results.filter(r => r.category === category);
  const passed = categoryResults.filter(r => r.passed).length;
  const failed = categoryResults.filter(r => !r.passed).length;

  totalPassed += passed;
  totalFailed += failed;

  console.log(`\n${category}:`);
  console.log("-".repeat(70));

  for (const result of categoryResults) {
    const status = result.passed ? "✓" : "✗";
    const icon = result.passed ? "🟢" : "🔴";
    console.log(`  ${icon} ${status} ${result.name}`);
    if (!result.passed) {
      console.log(`      ${result.message}`);
    }
  }
}

// Overall Score
console.log("\n" + "=".repeat(70));
console.log("OVERALL SCORE");
console.log("=".repeat(70));

const total = totalPassed + totalFailed;
const percentage = ((totalPassed / total) * 100).toFixed(1);

console.log(`\nPassed: ${totalPassed}/${total} (${percentage}%)`);
console.log(`Failed: ${totalFailed}/${total}`);

// Compliance Level
let level = "None";
let badge = "🔴";

if (percentage >= "95") {
  level = "Gold";
  badge = "🥇";
} else if (percentage >= "85") {
  level = "Silver";
  badge = "🥈";
} else if (percentage >= "75") {
  level = "Bronze";
  badge = "🥉";
} else if (percentage >= "50") {
  level = "Partial";
  badge = "🟡";
}

console.log(`\nCompliance Level: ${badge} ${level}`);

// Exit Code
if (totalFailed > 0) {
  console.log("\n⚠️  Some checks failed. See details above.");
  Deno.exit(1);
} else {
  console.log("\n✓ All RSR compliance checks passed!");
  Deno.exit(0);
}
