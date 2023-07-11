require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.6.29.tgz"
  sha256 "b297277e12dcdc5cfb98dd3b4450571b071db1c1985f2b550bfa9475d8228b94"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "437b91756774e144036af6edfa4af8ad50ab3055039336b822d89dc483f897f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "437b91756774e144036af6edfa4af8ad50ab3055039336b822d89dc483f897f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "437b91756774e144036af6edfa4af8ad50ab3055039336b822d89dc483f897f2"
    sha256 cellar: :any_skip_relocation, ventura:        "4795329648f5753bd7a7febb8f96a7b7c2aab297b7cbe342d61544ab7c1c62a5"
    sha256 cellar: :any_skip_relocation, monterey:       "4795329648f5753bd7a7febb8f96a7b7c2aab297b7cbe342d61544ab7c1c62a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "4795329648f5753bd7a7febb8f96a7b7c2aab297b7cbe342d61544ab7c1c62a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "437b91756774e144036af6edfa4af8ad50ab3055039336b822d89dc483f897f2"
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