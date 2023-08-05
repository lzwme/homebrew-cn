require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.6.37.tgz"
  sha256 "7bb0ef16bd26670463eae12416375e7b94d1b1945a1b4f5e895f199b5b20f8d8"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7756512898280bfc5d696d347e26725072889b14b1e2ef99a9128b6234269c66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7756512898280bfc5d696d347e26725072889b14b1e2ef99a9128b6234269c66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7756512898280bfc5d696d347e26725072889b14b1e2ef99a9128b6234269c66"
    sha256 cellar: :any_skip_relocation, ventura:        "78fb13e1f91e0ea36d6d88631656a97c13cadc146930491557d0fb2c2b8a000f"
    sha256 cellar: :any_skip_relocation, monterey:       "78fb13e1f91e0ea36d6d88631656a97c13cadc146930491557d0fb2c2b8a000f"
    sha256 cellar: :any_skip_relocation, big_sur:        "78fb13e1f91e0ea36d6d88631656a97c13cadc146930491557d0fb2c2b8a000f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7756512898280bfc5d696d347e26725072889b14b1e2ef99a9128b6234269c66"
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