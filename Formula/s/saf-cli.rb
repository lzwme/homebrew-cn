require "language/node"

class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.3.1.tgz"
  sha256 "0a0c62e80c2b7f8c4dee74a3e377d8b55133c20473705d3b9c962f5364c3d090"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3756feebec505212234ffe0f45f20aab872526c18cb63521c8f715bb5d8e011"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3756feebec505212234ffe0f45f20aab872526c18cb63521c8f715bb5d8e011"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3756feebec505212234ffe0f45f20aab872526c18cb63521c8f715bb5d8e011"
    sha256 cellar: :any_skip_relocation, sonoma:         "e9e41ccb9f4dcf3990083c6a15230308fb363821a33c3103fb159974246b5bae"
    sha256 cellar: :any_skip_relocation, ventura:        "e9e41ccb9f4dcf3990083c6a15230308fb363821a33c3103fb159974246b5bae"
    sha256 cellar: :any_skip_relocation, monterey:       "e9e41ccb9f4dcf3990083c6a15230308fb363821a33c3103fb159974246b5bae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e74bc22d9dbb42f212ac9f77e9e3e177ac4fc76234fea3202091f240627ffcc9"
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