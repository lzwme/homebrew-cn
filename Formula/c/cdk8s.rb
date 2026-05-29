class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.10.tgz"
  sha256 "b4ce867d73ddb81a3421e0a1780336a9826756c8b61df3168aae13de6806b37a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8f5112365c4741569dce77dc1bea8fc1182c111e03351aed842c47d91fd9b101"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end