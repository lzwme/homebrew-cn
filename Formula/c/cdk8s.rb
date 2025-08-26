class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.5.tgz"
  sha256 "171f6bae5be458eb54fbda1bb2e14b6f8f1c07209432fbe0b483bc6188a49d01"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7078fb6f48610473035261083bd853f7cd7cdd1014d6f73221c710e6b1719d4b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end