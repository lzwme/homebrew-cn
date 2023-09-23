require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.8.14.tgz"
  sha256 "294372e6f5ab53b4b68b227cf27673bdde501d6ba69166edd62a6647376704a1"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecd351bf7c194383c4778baafe840c19bd256e5cc823a1966ecde5517b931b52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecd351bf7c194383c4778baafe840c19bd256e5cc823a1966ecde5517b931b52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ecd351bf7c194383c4778baafe840c19bd256e5cc823a1966ecde5517b931b52"
    sha256 cellar: :any_skip_relocation, ventura:        "d6a11eea6b70739b570a44b7f47e54955f61968c9ea3fdf9c34613d928b2e3f5"
    sha256 cellar: :any_skip_relocation, monterey:       "d6a11eea6b70739b570a44b7f47e54955f61968c9ea3fdf9c34613d928b2e3f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6a11eea6b70739b570a44b7f47e54955f61968c9ea3fdf9c34613d928b2e3f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecd351bf7c194383c4778baafe840c19bd256e5cc823a1966ecde5517b931b52"
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