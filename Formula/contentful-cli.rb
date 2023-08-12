require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.6.40.tgz"
  sha256 "71e86c31a95df68c7a4b5c34bfc4075a70b48c50c7b643ff67c199ef697632bc"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58dcfd7c91825281fcf69d486e097bea6ddb29f39267e1cb6d167882f48cd9d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58dcfd7c91825281fcf69d486e097bea6ddb29f39267e1cb6d167882f48cd9d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58dcfd7c91825281fcf69d486e097bea6ddb29f39267e1cb6d167882f48cd9d1"
    sha256 cellar: :any_skip_relocation, ventura:        "e79b23b892f5dedd3021f62ab0976de4f5db1413fdccd3aa89ca736253076c02"
    sha256 cellar: :any_skip_relocation, monterey:       "e79b23b892f5dedd3021f62ab0976de4f5db1413fdccd3aa89ca736253076c02"
    sha256 cellar: :any_skip_relocation, big_sur:        "e79b23b892f5dedd3021f62ab0976de4f5db1413fdccd3aa89ca736253076c02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58dcfd7c91825281fcf69d486e097bea6ddb29f39267e1cb6d167882f48cd9d1"
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