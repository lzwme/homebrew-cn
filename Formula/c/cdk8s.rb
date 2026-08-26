class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.56.tgz"
  sha256 "e8192e63902f416926ce15192165147a00a128d12afe2a394febd72f6ce37a77"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c7210a9f8028b86351e1ec85560ee2e36ed9e51b736507ee8e77d479d3b6027b"
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