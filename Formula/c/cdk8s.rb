require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.98.0.tgz"
  sha256 "187fbab49638accb1d362850527a066f08a4f67063a567b24dfc32db110d2e03"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a558360b3b4b6006b04b8a9ef1ed4dcb171b72d4335842529c07ca1dd1c76a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a558360b3b4b6006b04b8a9ef1ed4dcb171b72d4335842529c07ca1dd1c76a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a558360b3b4b6006b04b8a9ef1ed4dcb171b72d4335842529c07ca1dd1c76a4"
    sha256 cellar: :any_skip_relocation, ventura:        "cbe4c96b4c4f32678b9cfebb2cb5d45086ed7a62321147c802e6494d5e4a21e3"
    sha256 cellar: :any_skip_relocation, monterey:       "cbe4c96b4c4f32678b9cfebb2cb5d45086ed7a62321147c802e6494d5e4a21e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbe4c96b4c4f32678b9cfebb2cb5d45086ed7a62321147c802e6494d5e4a21e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a558360b3b4b6006b04b8a9ef1ed4dcb171b72d4335842529c07ca1dd1c76a4"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end