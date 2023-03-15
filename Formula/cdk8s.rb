require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.159.tgz"
  sha256 "06c362b2dc386f8bd17ebcccd0769f54ef742e0b4b2bc6c69c6a7ebab2073c01"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a646fb4356f4ef5a08f74636df0dba834cd050dd970a6bc8086446fecc9276b8"
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