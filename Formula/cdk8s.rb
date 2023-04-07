require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.11.tgz"
  sha256 "30dc5142bef910ebb2ba6953fe7ac0afd6fc25f81f61d363c11592eda33e096f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "da2d68fc60f986505b12124401d78dc59044459d66ff67e72e598c05a2843108"
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