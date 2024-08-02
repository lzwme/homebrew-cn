class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.4.9.tgz"
  sha256 "0a339c37e79d95fca3b027abc5c7576cd70900a7d0d155b0b79f609c09657cfa"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c9bc3e0744a06423a7d8fe1a77df99f20496b436142d21e47bc47573c73703d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c9bc3e0744a06423a7d8fe1a77df99f20496b436142d21e47bc47573c73703d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c9bc3e0744a06423a7d8fe1a77df99f20496b436142d21e47bc47573c73703d"
    sha256 cellar: :any_skip_relocation, sonoma:         "570d99864a29ca3c2982dee8981c55b7480dff4eb5aafb1076fa3ac148714cac"
    sha256 cellar: :any_skip_relocation, ventura:        "570d99864a29ca3c2982dee8981c55b7480dff4eb5aafb1076fa3ac148714cac"
    sha256 cellar: :any_skip_relocation, monterey:       "7b66742740723e09129c55d0ba59696e236efdd4bcfa8b03d4cff9bd59d06440"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6635bf276d2880ed1e6f772b9cd01a69452d637946c6739263434d124908299d"
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