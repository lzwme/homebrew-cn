require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.6.39.tgz"
  sha256 "fa55c0cad58450ab6cd460eb6b0430f7fc2c2346778f54c7dcea7b322e4963b3"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db6f7943e7997b9541e94934e9ad0820fdf47607bd2e39ca4085aef0621894c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db6f7943e7997b9541e94934e9ad0820fdf47607bd2e39ca4085aef0621894c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db6f7943e7997b9541e94934e9ad0820fdf47607bd2e39ca4085aef0621894c1"
    sha256 cellar: :any_skip_relocation, ventura:        "4e9bd6e4915cfed5e726367ce90cbaf9c24e34a6359ed6e7dbee31eab30b8869"
    sha256 cellar: :any_skip_relocation, monterey:       "4e9bd6e4915cfed5e726367ce90cbaf9c24e34a6359ed6e7dbee31eab30b8869"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e9bd6e4915cfed5e726367ce90cbaf9c24e34a6359ed6e7dbee31eab30b8869"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db6f7943e7997b9541e94934e9ad0820fdf47607bd2e39ca4085aef0621894c1"
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