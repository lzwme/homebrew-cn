class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.203.11.tgz"
  sha256 "c0eb70306e4e13213ee2cef0ae7cbc53725bd9b7d7a6c167b5d0769d4bb57188"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0bfab2ebf9c5f7696218e70ac13a3b7ac78e02dd4864c5521c4a18014a2a2b1c"
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