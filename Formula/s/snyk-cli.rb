class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1301.2.tgz"
  sha256 "fcf2788c40e074cedd9e989ab52e1d8637d487874855ec872aac09e4cc0c816d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1cd7d27a33483726c630cc5b75084afb3417dcdbab9c963351a10bc6bc44b72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1cd7d27a33483726c630cc5b75084afb3417dcdbab9c963351a10bc6bc44b72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1cd7d27a33483726c630cc5b75084afb3417dcdbab9c963351a10bc6bc44b72"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea1f394aeb81bfb8b8949573c40d05effde8a5b3453d0d9cdd9da1dddc43172f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "978a314cb85566ee1cf0d00ac3e85663c3b3b611a1319808b5807134fe750e39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9192271b9d0e33e0aeb78baf63057ea423f618b033e04dc2407aeb815a11f4b7"
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