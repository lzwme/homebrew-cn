class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1308.0.tgz"
  sha256 "7b381ae414c5901333955fb3b1294ba10bcc057495ca847ef2b7054fc3d3f1f0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "79fa877203ef6c7799e82494a73eb0af6b2d8ccb638fbfeb5518becbd16dbdba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "79fa877203ef6c7799e82494a73eb0af6b2d8ccb638fbfeb5518becbd16dbdba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "79fa877203ef6c7799e82494a73eb0af6b2d8ccb638fbfeb5518becbd16dbdba"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3221cc09f04cb2702d4d27455cb91f68c93959d056aeccb80973080b8729251a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6c96cd523bbaebd67f2ea4b01586d09d6770d9d3c872dea2ee591afda5f3d12e"
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