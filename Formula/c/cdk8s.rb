class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.11.tgz"
  sha256 "7a37a4fe2dc96d1e20528256f3d4c49acd94ba8455fef4868ebc40b7bf156e61"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6337536d60073a2c90596ebf48993f27f08cbb1eeefa500794da906049219373"
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