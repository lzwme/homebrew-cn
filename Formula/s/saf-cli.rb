require "language/node"

class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.4.9.tgz"
  sha256 "0a339c37e79d95fca3b027abc5c7576cd70900a7d0d155b0b79f609c09657cfa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64c392d827c7d6ca8ecae905728f9c09730d5fee2aa6f208a4bd9fb04f058b3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64c392d827c7d6ca8ecae905728f9c09730d5fee2aa6f208a4bd9fb04f058b3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64c392d827c7d6ca8ecae905728f9c09730d5fee2aa6f208a4bd9fb04f058b3f"
    sha256 cellar: :any_skip_relocation, sonoma:         "38de545aa547a312aa3721d0d2fe0d201b8cffef85586d3a62172cbfdd596cfb"
    sha256 cellar: :any_skip_relocation, ventura:        "38de545aa547a312aa3721d0d2fe0d201b8cffef85586d3a62172cbfdd596cfb"
    sha256 cellar: :any_skip_relocation, monterey:       "38de545aa547a312aa3721d0d2fe0d201b8cffef85586d3a62172cbfdd596cfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3077cad9415c3ff4092ea3a81817fa54e50b56e462fd961f655bd53efe631c3"
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