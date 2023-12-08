require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.1.23.tgz"
  sha256 "a7aa9bdc0c5f29bfdea14ab423c4bb4490419c9e97c414ff6a306114bb25d862"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb3144f612d4f101cff53af0bab373cb525c63c1399b31c3f5e45920384a3ab4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb3144f612d4f101cff53af0bab373cb525c63c1399b31c3f5e45920384a3ab4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb3144f612d4f101cff53af0bab373cb525c63c1399b31c3f5e45920384a3ab4"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6604ab5b707f3d76adcaa1a0b900018e11d49040b2a25a4838b5cda80276915"
    sha256 cellar: :any_skip_relocation, ventura:        "f6604ab5b707f3d76adcaa1a0b900018e11d49040b2a25a4838b5cda80276915"
    sha256 cellar: :any_skip_relocation, monterey:       "f6604ab5b707f3d76adcaa1a0b900018e11d49040b2a25a4838b5cda80276915"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb3144f612d4f101cff53af0bab373cb525c63c1399b31c3f5e45920384a3ab4"
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