class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.3.tgz"
  sha256 "79d711405bec6583b151fa14812680b653db93f5e04caec791422e1843bd3c81"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9185283c9dda315ef49771c6e70f4fe7a92810ece1a997ee4fa9f8f92ce55573"
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