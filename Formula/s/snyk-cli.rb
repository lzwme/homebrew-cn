require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1255.0.tgz"
  sha256 "f5ad6e810bd2297739b572bb10c150cac2a35644a595a25999dd29999fddefb0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "227525dfec9da01d1de2121152a2cbe29360e77bf717ebe857cc40267d664faf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9c25a9853989f61ccda8519e01a78836a27accb181ec3a14d4f7bf69b34baa2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20504419b71155775d427e00ee65e5d5c8d376fd5432b6a0c0a1ce4aab3cd840"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c5559178c1a62ae20f914f53924096c44723c16b8843dc4f3ea2bc3875c5add"
    sha256 cellar: :any_skip_relocation, ventura:        "3f57db9a52e3b9db2d551314dff628e57f8481d184a1c1c76116d9b6ffbede15"
    sha256 cellar: :any_skip_relocation, monterey:       "749f7940d8a5bf327ddb21b52bfcbc495cdf84eed19c4caf19cd0aba873c4e01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9673494ec2dae10c9261faa1851602bfc586910d4c27b185db8ac435ce1de21"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "Authentication failed. Please check the API token on https://snyk.io", output
  end
end