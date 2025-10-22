class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1300.1.tgz"
  sha256 "fe3a7fb3105fd034bf573b6a877b4404298209643772287114a30eaf9b0990d2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7cfebf14d70eaf50ba61de741a7392f29b3a0d9558b15edb9ac3d8fe9f024bfd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cfebf14d70eaf50ba61de741a7392f29b3a0d9558b15edb9ac3d8fe9f024bfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cfebf14d70eaf50ba61de741a7392f29b3a0d9558b15edb9ac3d8fe9f024bfd"
    sha256 cellar: :any_skip_relocation, sonoma:        "292fb1c1b91f5981f0deee839f5fb3064d733f50f129c6e97e9343d7c67f53f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d460403ecabff18522375d41a03187f9f70e925992e290a8e294cc6f0e265dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63b50f154ff3dd70ffd761299d38022af477bd6040218c52ad12f4781685b473"
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