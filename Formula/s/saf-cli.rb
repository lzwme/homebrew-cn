require "language/node"

class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.4.6.tgz"
  sha256 "b4fe4ff1021328d0aee7403c01d9afef9750bd75445bafa366f72c2dfc1ed52f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac80b2df66f8105d636fa52f6b5527a3171d9c9b3b35af45f2ce8cc3a0781f69"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88ba9d250f1a97eef0fbe202a2f84062a52e1cc9872ee72dcb6d089a436ce15f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "868313c14c895738d64a9f0477499fb22440303822a087f548585fde14d11531"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe039489a39fc472bcfc2439974f812fd3f7d8ea4b048ec7e96b63d9f955d821"
    sha256 cellar: :any_skip_relocation, ventura:        "19e95ac18d51b52b542ff28ed026bc8743bd24917ce63cb521d7dcf427504fab"
    sha256 cellar: :any_skip_relocation, monterey:       "fe66e145c52135c8eed8c482babfb5616195b42d6d011d05239770982c4a53fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80437ab6594f28adcd584b723e6a48ec5510d936131946d4bc3dbef1c920409d"
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