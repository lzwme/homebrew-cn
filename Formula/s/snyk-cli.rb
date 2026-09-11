class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1307.2.tgz"
  sha256 "e45e6bbabf0161eba00fd90cf248f3c446a8f9ff183e835de3c9301fb7178924"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49d46397bb7bf6b8b96e3066cd952738137755d4436ee684357cc8b76c909135"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49d46397bb7bf6b8b96e3066cd952738137755d4436ee684357cc8b76c909135"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49d46397bb7bf6b8b96e3066cd952738137755d4436ee684357cc8b76c909135"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d38261c88097921764bcbac20def119c6448f0c4ba4cb4ea883751b49498d5cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31162bfc60fc822071f947aa06a4a9644aa37714b0488e8e1db6ab1b2ad86948"
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