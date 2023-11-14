require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1244.0.tgz"
  sha256 "e63e146b34a5e4e5aa61e3c438a6daf9d583496b9a143321a403908a5084fc12"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bf89efab0a8775807a5be24ba33d4a6790e4195aafc551099914dfc878c7844c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a76244019dc09c5598afc04b485299c3e63fc49a37e14672ac4df1d2b17e1199"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7607cac0aba1f25e84131edccdde4868ebc7bd79a3dd11183b654de822c0b631"
    sha256 cellar: :any_skip_relocation, sonoma:         "a5cb6a2bfb91d0a97580a7ec80ba16fc97e0fb7779036ad710a30efb1d433ac2"
    sha256 cellar: :any_skip_relocation, ventura:        "10a11d3a4acb94885486f499db3c92e0d61e53aa58ddc0d0dbb26a3afddf3682"
    sha256 cellar: :any_skip_relocation, monterey:       "677e0b98c93dfa600bb55ea4678fd8c59f98aaabdcf2d17aee1bff4cbe0631a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17b444fbbf57292d6d2e2a7cd80837253626872639b4b4e6240b591ffbb12f12"
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