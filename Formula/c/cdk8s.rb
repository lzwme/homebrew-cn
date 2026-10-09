class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.64.tgz"
  sha256 "96f4f5232ca72dd7384f27e5b71e96557ced51155198fb49f2025092b2a92357"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e1cf6ce6fcdc495208a6dc384c5d0f2fe6b73be0d8c5be6d1b0ba3450a805210"
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