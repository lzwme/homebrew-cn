require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.1.3.tgz"
  sha256 "8996f40496bff33d2ec7f07fd772ca01b52800b908fecc31e8f94540d25d58ba"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1caaa6427ee051d8f3f39a2e8bb3c028a70ffa62eababe6d681169db133d8875"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1caaa6427ee051d8f3f39a2e8bb3c028a70ffa62eababe6d681169db133d8875"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1caaa6427ee051d8f3f39a2e8bb3c028a70ffa62eababe6d681169db133d8875"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad263676a8f4227eeecb91c2dc62adb7661bd2b0b59efa777a207ce46df8de62"
    sha256 cellar: :any_skip_relocation, ventura:        "d4b0c24dc18dd61fb8827a509258318071130f0e4d163f9d51eab1b8ca1de731"
    sha256 cellar: :any_skip_relocation, monterey:       "d4b0c24dc18dd61fb8827a509258318071130f0e4d163f9d51eab1b8ca1de731"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1caaa6427ee051d8f3f39a2e8bb3c028a70ffa62eababe6d681169db133d8875"
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