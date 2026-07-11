class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1306.0.tgz"
  sha256 "6ea32751b2d07f8902663ee9d9489aa1f2a7dab036b1f56da7d57a82d2ba25ce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f97e369c9469bad79c5fb34e1b86b9e8234e955c9ff7d3045237a8abfbdaedfa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f97e369c9469bad79c5fb34e1b86b9e8234e955c9ff7d3045237a8abfbdaedfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f97e369c9469bad79c5fb34e1b86b9e8234e955c9ff7d3045237a8abfbdaedfa"
    sha256 cellar: :any_skip_relocation, sonoma:        "abe42f172ebd71d66670675d927eae9db44ea81a8ab1a4a42465bd0b944f1469"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccf88dd2d40c0664bdd97d8590a0d31fca6c6852c95debb904d998d204c17d01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c59125541e7e8b3caa923826f9b91a17cc7180a0f9eaa6af482e0a5a3827425"
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