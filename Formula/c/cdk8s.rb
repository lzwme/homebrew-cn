class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.2.tgz"
  sha256 "5a304ef6b8ab2bb9de9666598b10c0609a55a6e9074718fecc0c2e2a5a0c873a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cf589cc7d1c0c03c219acd84c4be20d9c24fa1aadca7884e5acf49036ee56169"
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