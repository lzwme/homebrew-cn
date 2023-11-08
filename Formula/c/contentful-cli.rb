require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.1.11.tgz"
  sha256 "2dd8bdd699246c506dccd36c4739ea2a90da647efaeca1346fe9d5d25bfe87b5"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8f3d3f37b947ce73b5ec0b8dda9dc0fc2fc20617372fbfefe76f672b8c81fa8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8f3d3f37b947ce73b5ec0b8dda9dc0fc2fc20617372fbfefe76f672b8c81fa8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8f3d3f37b947ce73b5ec0b8dda9dc0fc2fc20617372fbfefe76f672b8c81fa8"
    sha256 cellar: :any_skip_relocation, sonoma:         "33b763f5a39549a5178cc053049cef7ab8529335927f48466dd1dc52f98e5f4b"
    sha256 cellar: :any_skip_relocation, ventura:        "33b763f5a39549a5178cc053049cef7ab8529335927f48466dd1dc52f98e5f4b"
    sha256 cellar: :any_skip_relocation, monterey:       "33b763f5a39549a5178cc053049cef7ab8529335927f48466dd1dc52f98e5f4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8f3d3f37b947ce73b5ec0b8dda9dc0fc2fc20617372fbfefe76f672b8c81fa8"
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