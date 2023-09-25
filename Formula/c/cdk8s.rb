require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.101.0.tgz"
  sha256 "c4d148c124292cf0a04b426071acb4810bff639a09579eee1547900a3d82da6e"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2005a0a737d31ce56f7864fa7381de893c734a121f1e4a71bdf0b16ed0995b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2005a0a737d31ce56f7864fa7381de893c734a121f1e4a71bdf0b16ed0995b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2005a0a737d31ce56f7864fa7381de893c734a121f1e4a71bdf0b16ed0995b2"
    sha256 cellar: :any_skip_relocation, ventura:        "c9cc1de99b4dfc88383e52b86fef6607810898e891275da57e18919938106c6d"
    sha256 cellar: :any_skip_relocation, monterey:       "c9cc1de99b4dfc88383e52b86fef6607810898e891275da57e18919938106c6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9cc1de99b4dfc88383e52b86fef6607810898e891275da57e18919938106c6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2005a0a737d31ce56f7864fa7381de893c734a121f1e4a71bdf0b16ed0995b2"
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