require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.166.tgz"
  sha256 "717fdff00d0cfb9ce875727ee562b456557fedcda03ad6ecf1e95c31bd3e668a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2cb41abcd7e95d304842356ab802f2176481f3f5f03933d8a60aca2a61c8136b"
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