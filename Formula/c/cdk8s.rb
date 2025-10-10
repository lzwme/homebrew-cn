class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.50.tgz"
  sha256 "83d1a86a8d84f8ee2cc6877a50713967fd63b9e2471c3e2917d79062e79b7f1e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f30c96c96842fd16bf3bfc74afd15af7076ffc65a28b8bf4f0757bdbaf362cd1"
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