class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.203.15.tgz"
  sha256 "e3c7e0beb5ad4118c95303e253c472196f8c3c60b93783337d1ef44ed1c0f696"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "01aa62ef8cf26fc089ea43a09e9c52892c177923b4cab72e737321998255d8ee"
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