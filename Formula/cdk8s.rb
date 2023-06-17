require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.61.tgz"
  sha256 "b86f995e1f008acd0cf018d72476755cd41ff48ef63a33f2fc0d839f5f59f0fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9509615615cf62ee8ec89387f9142fb73967144f58bd3ab856bd6fd40943d4d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9509615615cf62ee8ec89387f9142fb73967144f58bd3ab856bd6fd40943d4d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9509615615cf62ee8ec89387f9142fb73967144f58bd3ab856bd6fd40943d4d7"
    sha256 cellar: :any_skip_relocation, ventura:        "d5fab4711c4ba6b64487fe823978cf1d8ccb5af47c1dc91002a79115feb39ccc"
    sha256 cellar: :any_skip_relocation, monterey:       "d5fab4711c4ba6b64487fe823978cf1d8ccb5af47c1dc91002a79115feb39ccc"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5fab4711c4ba6b64487fe823978cf1d8ccb5af47c1dc91002a79115feb39ccc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9509615615cf62ee8ec89387f9142fb73967144f58bd3ab856bd6fd40943d4d7"
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