require "language/node"

class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.4.7.tgz"
  sha256 "f84182276911340cc2e2893ba6e2c19d6d1812f524d4083eaca32c2697606069"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5cdc0bfa46bf2cf3dd6db708a7647dd70a8796df45282a7d761ddd35080fdfac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5cdc0bfa46bf2cf3dd6db708a7647dd70a8796df45282a7d761ddd35080fdfac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cdc0bfa46bf2cf3dd6db708a7647dd70a8796df45282a7d761ddd35080fdfac"
    sha256 cellar: :any_skip_relocation, sonoma:         "24e220ae22db11002731309c24b64986683df3f33ad59fe1615173dbac4a0acb"
    sha256 cellar: :any_skip_relocation, ventura:        "24e220ae22db11002731309c24b64986683df3f33ad59fe1615173dbac4a0acb"
    sha256 cellar: :any_skip_relocation, monterey:       "24e220ae22db11002731309c24b64986683df3f33ad59fe1615173dbac4a0acb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d103fd0234f58b0b2bc4f7be2107c5ffb07a83faca7d93a66216cb945ac33e8"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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