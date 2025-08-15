class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.154.tgz"
  sha256 "48b859e87c33a124e32f8bbbcb0044e107f1cd086116533734b73c31468837cd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7b1a64b834ebc56caa244743d589c29ff9a7847105c1c680194ccc400ca4c36b"
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