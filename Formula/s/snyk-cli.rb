class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1294.0.tgz"
  sha256 "d777267fecbb46e7237b3d6fff36a2068af0be862dc4fcb5fe3e37d1740078d4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b437b39b3ceb61f83ef2dcc5eb761edd745ab3d9d57895d05e30ce99e8779f19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b437b39b3ceb61f83ef2dcc5eb761edd745ab3d9d57895d05e30ce99e8779f19"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b437b39b3ceb61f83ef2dcc5eb761edd745ab3d9d57895d05e30ce99e8779f19"
    sha256 cellar: :any_skip_relocation, sonoma:        "79160cdce8682772a7799a46d0d65091352bb5cdc53b1caff6b3dab99ee1b527"
    sha256 cellar: :any_skip_relocation, ventura:       "79160cdce8682772a7799a46d0d65091352bb5cdc53b1caff6b3dab99ee1b527"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3f1de69848e41f3899ca48273b2042b6585be7203515e86c60fda19e4e7f702"
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