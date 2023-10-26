require "language/node"

class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.2.33.tgz"
  sha256 "3608de97aa36ab55c791b71fda2f019225d470d7196bd3e3095b922b06e2d3ec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40a3d5da81018972767c1b0358b0ea83e5a5988107760389d9f0132610e0d193"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40a3d5da81018972767c1b0358b0ea83e5a5988107760389d9f0132610e0d193"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40a3d5da81018972767c1b0358b0ea83e5a5988107760389d9f0132610e0d193"
    sha256 cellar: :any_skip_relocation, sonoma:         "84487d76fbd79fb180eae6a95db84ade1b42366d01b75730ffbc6df4b3030e92"
    sha256 cellar: :any_skip_relocation, ventura:        "84487d76fbd79fb180eae6a95db84ade1b42366d01b75730ffbc6df4b3030e92"
    sha256 cellar: :any_skip_relocation, monterey:       "84487d76fbd79fb180eae6a95db84ade1b42366d01b75730ffbc6df4b3030e92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90ff23459666351b6dae7347baf44c9bcad46b22f709a482767a0050740fd0ab"
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