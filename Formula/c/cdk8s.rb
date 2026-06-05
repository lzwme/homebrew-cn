class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.14.tgz"
  sha256 "5064795e2b1eea144f33edf953dd10b7742447a7f591af1bcb268a6353d568be"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a81dc2db3530b7c21336e359876a1b53626b8a368806a334171d59383798b77d"
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