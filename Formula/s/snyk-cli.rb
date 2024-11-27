class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1294.2.tgz"
  sha256 "dbc9674a8725afcd3d97b1f2488572855f5d84f614ac8c8d9f7035a7d5a309cc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "733664b4eaa4874bcc361efe0b35b46c072a83bca4cccf1df7a2eaf57deb3b36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "733664b4eaa4874bcc361efe0b35b46c072a83bca4cccf1df7a2eaf57deb3b36"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "733664b4eaa4874bcc361efe0b35b46c072a83bca4cccf1df7a2eaf57deb3b36"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf9a6b7ea70863662f5dea0fb14d894f5e7bcd398f242647cac662494670fe81"
    sha256 cellar: :any_skip_relocation, ventura:       "cf9a6b7ea70863662f5dea0fb14d894f5e7bcd398f242647cac662494670fe81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67c5ea7698f9046215a14fc56b63f1185d42dd45c99729d34171fe9813d89096"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "authentication failed (timeout)", output
  end
end