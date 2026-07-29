class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1306.2.tgz"
  sha256 "9cb069a5238cefdae9ab69777a98eba46500551b74da88ca9d1da9238552937b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "599637fc94ad8ae081ecbf24ace9021cb0f6d4e021e89cd0ef46bf2d19dfedc6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "599637fc94ad8ae081ecbf24ace9021cb0f6d4e021e89cd0ef46bf2d19dfedc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "599637fc94ad8ae081ecbf24ace9021cb0f6d4e021e89cd0ef46bf2d19dfedc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ad0210c7909c1e63cc713dbf4baac09c2d47f959c0ad097a6ab75382b633715"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cd697e64d7034113e37b1bd704feb293bf3b60d64b55ee7e53ce627f74b84ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "995abdececb2cc947a5b081481ab71e6284a12758b324987cf7a40ce93d79713"
  end

  depends_on "node"

  def install
    # Highly dependents on npm scripts to install wrapper bin files
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

    # Remove x86-64 ELF binaries on incompatible platforms
    # TODO: Check if these should be built from source
    rm(libexec.glob("lib/node_modules/snyk/dist/cli/*.node")) if !OS.linux? || !Hardware::CPU.intel?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "authentication failed (timeout)", output
  end
end