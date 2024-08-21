class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.4.12.tgz"
  sha256 "e31672adb7542c2ba47f9e6e88c8520e95c98e6d6247a91cbc6b60524aa4034b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "82c936a6dd6fa2b21d672782c7c87ec2b5d1e23ac76765b8770b79d886d5b9bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82c936a6dd6fa2b21d672782c7c87ec2b5d1e23ac76765b8770b79d886d5b9bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82c936a6dd6fa2b21d672782c7c87ec2b5d1e23ac76765b8770b79d886d5b9bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "fdfb1835369ce15c1dd27a09fa3fe5788111a5a7ca62e4fd43fec8c247e1acdf"
    sha256 cellar: :any_skip_relocation, ventura:        "fdfb1835369ce15c1dd27a09fa3fe5788111a5a7ca62e4fd43fec8c247e1acdf"
    sha256 cellar: :any_skip_relocation, monterey:       "fdfb1835369ce15c1dd27a09fa3fe5788111a5a7ca62e4fd43fec8c247e1acdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82c936a6dd6fa2b21d672782c7c87ec2b5d1e23ac76765b8770b79d886d5b9bd"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/saf --version")

    output = shell_output("#{bin}/saf scan")
    assert_match "Visit https://saf.mitre.org/#/validate to explore and run inspec profiles", output
  end
end