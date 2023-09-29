require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.8.24.tgz"
  sha256 "04686355ae7b07426890453efc84c549954e71859916bf0ef3e5f0f1d2fc3fb3"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fbc6465e162d5482a78da57e4fb04b7b693694f4afe5266d98abf2245d3342c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbc6465e162d5482a78da57e4fb04b7b693694f4afe5266d98abf2245d3342c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbc6465e162d5482a78da57e4fb04b7b693694f4afe5266d98abf2245d3342c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a47eed68960799fde0c15bede3579a89333576b0ba2556e02bae471b04e8382"
    sha256 cellar: :any_skip_relocation, ventura:        "3a47eed68960799fde0c15bede3579a89333576b0ba2556e02bae471b04e8382"
    sha256 cellar: :any_skip_relocation, monterey:       "6eeb3afa13c768fb712dae6752b87a861cd9dd8432cf502c4f34f509f3a572c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbc6465e162d5482a78da57e4fb04b7b693694f4afe5266d98abf2245d3342c9"
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