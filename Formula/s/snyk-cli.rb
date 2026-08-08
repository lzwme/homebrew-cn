class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1306.3.tgz"
  sha256 "84f49813281bbff120b1418ebb6efb8c0c156700c949458ceda2b33e1330a63d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8fe2f5519736b68222c5845529da094d97622185a89a286103470b7dd91b793"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8fe2f5519736b68222c5845529da094d97622185a89a286103470b7dd91b793"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8fe2f5519736b68222c5845529da094d97622185a89a286103470b7dd91b793"
    sha256 cellar: :any_skip_relocation, sonoma:        "00464524df7a18fe3e0031ed591d02cfdb00106a98d0e005011260192d825b25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f667697350b7e5ad6a2152e2b90a6375b1583ba8d17edfc4169335504b86e60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a4d00bea43a58e8782326b709267b7c0c2e25da7db64e030189278b3c6da67b"
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