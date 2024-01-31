require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1276.0.tgz"
  sha256 "3a92c8abd6c2354eda029d53ca5ba8926abcae74e2a01b7fa5864137df1ff543"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f5e6da20ab40eb8d6ac8498a455d2eeab5fff27c4eeaf08d8a30315ec504feb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f15fb44126c2a1884919c71387d74ea6b821b0378a989b82319b9def31e3fac1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "235380a45e89a4c333def4c9c22981ea80d2358d18f736c007381320b6cbbb50"
    sha256 cellar: :any_skip_relocation, sonoma:         "6cad101ab1c3410fd3d6408a92247bd775a56752c940179ce4501c0023ea99f6"
    sha256 cellar: :any_skip_relocation, ventura:        "d09e24aabc14137d32948b1530a632c842a3bd87a3651260da30952a629ed8b0"
    sha256 cellar: :any_skip_relocation, monterey:       "55d3702720efb44b1198ca93ced7eabf29dd10e0feb0c50765417c7e46ef0cf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95020c9248b4cdaf9f0be2816a1640cdb37627bd8b0d05fe5519a40da5aed20d"
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