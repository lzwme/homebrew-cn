class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1300.0.tgz"
  sha256 "60d2dc3d818028f96d2237cda839cd1cdce8e9938abb717818cfd5cbc224218a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77f59b6a7382988d97bf6bd73cbacd88816408b5cd1db2ef6d6db686f1c35088"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77f59b6a7382988d97bf6bd73cbacd88816408b5cd1db2ef6d6db686f1c35088"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77f59b6a7382988d97bf6bd73cbacd88816408b5cd1db2ef6d6db686f1c35088"
    sha256 cellar: :any_skip_relocation, sonoma:        "f82b3cded6548fdb005e9a84fb3e304c05c653820385cbdd8196492439cc2850"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6728e849672919b2947dbb4488c9fd7de092bc1ea169f64da680a4e41f7221f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c769464f49ff924176f5802d392114c785822d0e483a0ed59b7da8c99433ed9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

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