class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1304.1.tgz"
  sha256 "89c00360124737027e6742fe41b725fa85731810361af40de9d6016528be0108"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01fc44c11e01e9ae50f6233feef0a3a78ce07b77f000497b31c93df39ee74e42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01fc44c11e01e9ae50f6233feef0a3a78ce07b77f000497b31c93df39ee74e42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01fc44c11e01e9ae50f6233feef0a3a78ce07b77f000497b31c93df39ee74e42"
    sha256 cellar: :any_skip_relocation, sonoma:        "293a3f1cdf72ba0718d76c259ac37366e163448b81f73bc06f8ad8053f5d71da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18f09492457c84c7a0227ddd860177ae5430495479000f1ed7a01f7338776643"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea344b9fdd353c461bda7c26fd8509e08f173af17a6c510249527c2760ec3858"
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