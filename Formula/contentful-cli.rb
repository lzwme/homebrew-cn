require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.6.38.tgz"
  sha256 "e497cfcf0d287fe0fd6f2bd0fbc12a2f72415d5f15866d0de85450dac03e7943"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f89dc4b67f19d4e0c8511426f8a380046f1ea6ad09b747e39f1024d9b2d9f86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f89dc4b67f19d4e0c8511426f8a380046f1ea6ad09b747e39f1024d9b2d9f86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f89dc4b67f19d4e0c8511426f8a380046f1ea6ad09b747e39f1024d9b2d9f86"
    sha256 cellar: :any_skip_relocation, ventura:        "9d981fc9c9f67573dbed16a07222aa48f7bbbe072c815a81c7985eceda4b7409"
    sha256 cellar: :any_skip_relocation, monterey:       "9d981fc9c9f67573dbed16a07222aa48f7bbbe072c815a81c7985eceda4b7409"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d981fc9c9f67573dbed16a07222aa48f7bbbe072c815a81c7985eceda4b7409"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f89dc4b67f19d4e0c8511426f8a380046f1ea6ad09b747e39f1024d9b2d9f86"
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