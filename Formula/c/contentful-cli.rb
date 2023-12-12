require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.1.27.tgz"
  sha256 "105ebf6569a395ae7f2f443bb9e1f1fc0d9f0a40ec89401d8993980480d50c18"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e0172c7332cabe70ee24eea219f0bb3262286c18e9be3570ddb53fb4cdc0478"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e0172c7332cabe70ee24eea219f0bb3262286c18e9be3570ddb53fb4cdc0478"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e0172c7332cabe70ee24eea219f0bb3262286c18e9be3570ddb53fb4cdc0478"
    sha256 cellar: :any_skip_relocation, sonoma:         "114f3325b4d3b51e31977a89ce1b8671e9373acd501feeeca0e03c8433d92c31"
    sha256 cellar: :any_skip_relocation, ventura:        "114f3325b4d3b51e31977a89ce1b8671e9373acd501feeeca0e03c8433d92c31"
    sha256 cellar: :any_skip_relocation, monterey:       "114f3325b4d3b51e31977a89ce1b8671e9373acd501feeeca0e03c8433d92c31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e0172c7332cabe70ee24eea219f0bb3262286c18e9be3570ddb53fb4cdc0478"
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