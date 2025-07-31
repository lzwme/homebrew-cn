class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1298.2.tgz"
  sha256 "ac4387c3b83a4944eb711f1ebeacfd1f190dc08045caee053576e4c8a5160f98"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac610484fe6aebe1acc5499fb3eb0d96adf34960bc6a0177ad4597f50355a0b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac610484fe6aebe1acc5499fb3eb0d96adf34960bc6a0177ad4597f50355a0b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ac610484fe6aebe1acc5499fb3eb0d96adf34960bc6a0177ad4597f50355a0b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c177818255caadf5a451daea5f4b2edaa79f59d990b26e1464427d2962438534"
    sha256 cellar: :any_skip_relocation, ventura:       "c177818255caadf5a451daea5f4b2edaa79f59d990b26e1464427d2962438534"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73a73dde3570c1c683c948a21433ff87358afcb2432181ad68118c6408b3e2c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea611d03d31f77a5a8086b02eeab5f767a79e79ad2c830065cad660369ece465"
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