require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.8.6.tgz"
  sha256 "7f1ca86f564e2181bdfb5d93ae41381a7a56e308a27bf50112fefd0b1c6bf3d0"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ccbd15749eee27189ccb27ad63dac5b9a1a9a04cb6569145c39fe8d3a46b313"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ccbd15749eee27189ccb27ad63dac5b9a1a9a04cb6569145c39fe8d3a46b313"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ccbd15749eee27189ccb27ad63dac5b9a1a9a04cb6569145c39fe8d3a46b313"
    sha256 cellar: :any_skip_relocation, ventura:        "bf222c56276a4ecbbba77b4ec436d52d53a9e6da0e90c620071945b45710712d"
    sha256 cellar: :any_skip_relocation, monterey:       "bf222c56276a4ecbbba77b4ec436d52d53a9e6da0e90c620071945b45710712d"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf222c56276a4ecbbba77b4ec436d52d53a9e6da0e90c620071945b45710712d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ccbd15749eee27189ccb27ad63dac5b9a1a9a04cb6569145c39fe8d3a46b313"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end