class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1297.0.tgz"
  sha256 "37fea0a588399299c837c5da374771e87196cf54f909cae748aacc0623ad754d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44eb6c987660c1c15e54b565b9fc0e67d9f1883bf52ef00419457419c93a0156"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44eb6c987660c1c15e54b565b9fc0e67d9f1883bf52ef00419457419c93a0156"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44eb6c987660c1c15e54b565b9fc0e67d9f1883bf52ef00419457419c93a0156"
    sha256 cellar: :any_skip_relocation, sonoma:        "02acc799ce455f3cf9b2c5a4818204c0349d62c1aa33e0b380b271b6b956b824"
    sha256 cellar: :any_skip_relocation, ventura:       "02acc799ce455f3cf9b2c5a4818204c0349d62c1aa33e0b380b271b6b956b824"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edbc440ab245588118c5d9c090811f92a3b31edaea95bfd0d94ed5ab5d2b7731"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00a81ba4f815c1265d44cb83e33faeb25417f1c19fdee43af41e82f4bfa7808a"
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