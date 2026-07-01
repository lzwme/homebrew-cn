class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.32.tgz"
  sha256 "c3bf1e415c48920e7f317de9491b58397a8ee8e41309ad57e70bbc2221f56da1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "719bbd92f2e294407ba3e98093f8946a0e3eac5b1b3d8fe9d7fe3f0df3ab81ca"
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