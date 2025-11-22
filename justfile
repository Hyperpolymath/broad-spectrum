# Broad Spectrum Website Auditor - Justfile
# Cross-platform task runner
# Install: https://github.com/casey/just
# Usage: just <recipe>

# Default recipe (list all recipes)
default:
    @just --list

# Build the project
build:
    @echo "Building ReScript modules..."
    npm run build
    @echo "✓ Build complete"

# Clean build artifacts
clean:
    @echo "Cleaning build artifacts..."
    npm run clean
    rm -rf lib/
    @echo "✓ Clean complete"

# Full rebuild (clean + build)
rebuild: clean build

# Install dependencies
install:
    @echo "Installing npm dependencies..."
    npm install
    @echo "✓ Dependencies installed"

# Run all tests
test:
    @echo "Running tests..."
    deno test --allow-net --allow-read
    @echo "✓ All tests passed"

# Run tests with coverage
test-coverage:
    @echo "Running tests with coverage..."
    deno test --allow-net --allow-read --coverage=coverage
    deno coverage coverage
    @echo "✓ Coverage report generated"

# Run a specific test file
test-file FILE:
    @echo "Running {{FILE}}..."
    deno test --allow-net --allow-read {{FILE}}

# Audit a single URL
audit URL:
    deno task audit --url {{URL}}

# Audit a single URL with JSON output
audit-json URL:
    deno task audit --url {{URL}} --format json

# Audit a single URL with HTML output
audit-html URL OUTPUT="report.html":
    deno task audit --url {{URL}} --format html > {{OUTPUT}}
    @echo "✓ HTML report saved to {{OUTPUT}}"

# Audit multiple URLs from file
audit-file FILE:
    deno task audit --file {{FILE}}

# Audit with verbose output
audit-verbose URL:
    deno task audit --url {{URL}} --verbose

# Watch mode for development
watch:
    npm run watch

# Format check (dry run)
format-check:
    @echo "Checking code formatting..."
    deno fmt --check src/ tests/
    @echo "✓ Format check passed"

# Format code
format:
    @echo "Formatting code..."
    deno fmt src/ tests/
    @echo "✓ Code formatted"

# Lint check
lint:
    @echo "Linting code..."
    deno lint src/ tests/
    @echo "✓ Lint check passed"

# Type check
typecheck:
    @echo "Type checking..."
    npm run build
    @echo "✓ Type check passed"

# Run all quality checks
check: format-check lint typecheck test
    @echo "✓ All quality checks passed"

# Verify RSR compliance
verify-rsr:
    @echo "Verifying RSR compliance..."
    @deno run --allow-read scripts/verify-rsr.ts
    @echo "✓ RSR compliance verified"

# Generate documentation
docs:
    @echo "Generating documentation..."
    @echo "Documentation is in:"
    @echo "  - README.md (user guide)"
    @echo "  - ARCHITECTURE.md (design docs)"
    @echo "  - CONTRIBUTING.md (contributor guide)"
    @echo "  - API documentation: See source code comments"

# Show project statistics
stats:
    @echo "Project Statistics:"
    @echo "=================="
    @echo "Lines of Code:"
    @find src -name "*.res" -o -name "*.ts" | xargs wc -l | tail -1
    @echo ""
    @echo "ReScript Modules:"
    @find src -name "*.res" | wc -l
    @echo ""
    @echo "TypeScript Files:"
    @find src -name "*.ts" | wc -l
    @echo ""
    @echo "Test Files:"
    @find tests -name "*.ts" | wc -l
    @echo ""
    @echo "Documentation Files:"
    @find . -maxdepth 1 -name "*.md" | wc -l

# Check for security vulnerabilities
security-check:
    @echo "Checking for security vulnerabilities..."
    npm audit
    @echo "✓ Security check complete"

# Validate .well-known files
validate-wellknown:
    @echo "Validating .well-known files..."
    @test -f .well-known/security.txt && echo "✓ security.txt exists"
    @test -f .well-known/ai.txt && echo "✓ ai.txt exists"
    @test -f .well-known/humans.txt && echo "✓ humans.txt exists"

# Validate required documentation
validate-docs:
    @echo "Validating documentation..."
    @test -f README.md && echo "✓ README.md exists"
    @test -f LICENSE && echo "✓ LICENSE exists"
    @test -f SECURITY.md && echo "✓ SECURITY.md exists"
    @test -f CONTRIBUTING.md && echo "✓ CONTRIBUTING.md exists"
    @test -f CODE_OF_CONDUCT.md && echo "✓ CODE_OF_CONDUCT.md exists"
    @test -f MAINTAINERS.md && echo "✓ MAINTAINERS.md exists"
    @test -f CHANGELOG.md && echo "✓ CHANGELOG.md exists"
    @test -f ARCHITECTURE.md && echo "✓ ARCHITECTURE.md exists"

# Full validation (docs + wellknown + RSR)
validate: validate-docs validate-wellknown verify-rsr
    @echo "✓ All validation checks passed"

# Create a new release
release VERSION:
    @echo "Creating release {{VERSION}}..."
    @echo "Updating version in package.json..."
    @sed -i 's/"version": ".*"/"version": "{{VERSION}}"/' package.json
    @echo "Updating CHANGELOG.md..."
    @echo "Please manually update CHANGELOG.md with release notes"
    @echo "Then run: git tag v{{VERSION}} && git push --tags"

# Example audit (uses example.com)
example:
    just audit "https://example.com"

# Example with all formats
example-all:
    @echo "Console output:"
    just audit "https://example.com"
    @echo ""
    @echo "JSON output:"
    just audit-json "https://example.com"
    @echo ""
    @echo "HTML output (saved to example-report.html):"
    just audit-html "https://example.com" "example-report.html"

# Clean everything (including node_modules)
clean-all: clean
    @echo "Removing node_modules..."
    rm -rf node_modules/
    @echo "✓ All clean"

# Setup development environment
setup: install build
    @echo "✓ Development environment ready"
    @echo "Run 'just test' to verify everything works"

# Run a quick health check
health:
    @echo "Running health check..."
    @echo "Node.js version:"
    @node --version
    @echo "npm version:"
    @npm --version
    @echo "Deno version:"
    @deno --version | head -1
    @echo "ReScript compiler:"
    @npx rescript -version
    @echo "✓ Health check complete"

# Show RSR compliance status
rsr-status:
    @echo "RSR Compliance Status"
    @echo "===================="
    @echo ""
    @echo "Documentation:"
    @test -f README.md && echo "  ✓ README.md" || echo "  ✗ README.md"
    @test -f LICENSE && echo "  ✓ LICENSE" || echo "  ✗ LICENSE"
    @test -f SECURITY.md && echo "  ✓ SECURITY.md" || echo "  ✗ SECURITY.md"
    @test -f CONTRIBUTING.md && echo "  ✓ CONTRIBUTING.md" || echo "  ✗ CONTRIBUTING.md"
    @test -f CODE_OF_CONDUCT.md && echo "  ✓ CODE_OF_CONDUCT.md" || echo "  ✗ CODE_OF_CONDUCT.md"
    @test -f CHANGELOG.md && echo "  ✓ CHANGELOG.md" || echo "  ✗ CHANGELOG.md"
    @echo ""
    @echo ".well-known:"
    @test -f .well-known/security.txt && echo "  ✓ security.txt" || echo "  ✗ security.txt"
    @test -f .well-known/ai.txt && echo "  ✓ ai.txt" || echo "  ✗ ai.txt"
    @test -f .well-known/humans.txt && echo "  ✓ humans.txt" || echo "  ✗ humans.txt"
    @echo ""
    @echo "Build System:"
    @test -f package.json && echo "  ✓ package.json" || echo "  ✗ package.json"
    @test -f rescript.json && echo "  ✓ rescript.json" || echo "  ✗ rescript.json"
    @test -f deno.json && echo "  ✓ deno.json" || echo "  ✗ deno.json"
    @test -f justfile && echo "  ✓ justfile" || echo "  ✗ justfile"
    @echo ""
    @echo "For detailed compliance report, run: just verify-rsr"

# Help message
help:
    @echo "Broad Spectrum Website Auditor - Task Runner"
    @echo ""
    @echo "Common Commands:"
    @echo "  just build           - Build the project"
    @echo "  just test            - Run all tests"
    @echo "  just audit URL       - Audit a website"
    @echo "  just check           - Run all quality checks"
    @echo "  just validate        - Validate RSR compliance"
    @echo ""
    @echo "For full list of commands: just --list"
    @echo "For detailed help: just --help"
