require "language/node"

class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.4.2.tgz"
  sha256 "6eaf661df11dd17d05b2ece97399994879896f1bed3f9860ffeda1c37824487e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e5023d362ff41f396fb7b46f3bd37d4e3bb2ea24678cfb95cd20919f1139ff4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e5023d362ff41f396fb7b46f3bd37d4e3bb2ea24678cfb95cd20919f1139ff4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e5023d362ff41f396fb7b46f3bd37d4e3bb2ea24678cfb95cd20919f1139ff4"
    sha256 cellar: :any_skip_relocation, sonoma:         "54f880ed82e21bce3c12170260ca2708dfedda5a12013451942473cb27b8eeb1"
    sha256 cellar: :any_skip_relocation, ventura:        "54f880ed82e21bce3c12170260ca2708dfedda5a12013451942473cb27b8eeb1"
    sha256 cellar: :any_skip_relocation, monterey:       "b2954afe056393dddf1a4f8dccaa3f537faafc515ad7ad329daf98e920dfcc32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e5023d362ff41f396fb7b46f3bd37d4e3bb2ea24678cfb95cd20919f1139ff4"
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