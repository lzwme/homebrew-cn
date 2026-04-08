class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.206.1.tgz"
  sha256 "011cd0c1810d30b60ca3e5876dd78007c88dd9be9cc190cc1ca4758a3f443fb3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4d234529623d2a5f501ec43e2aed03fb5e942ae185d9c64e656070bbff9049d0"
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