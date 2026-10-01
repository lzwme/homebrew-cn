class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.63.tgz"
  sha256 "c5b02ea4bdba831f158dff1231d1b40a4e68c373254d935cf3ec2199279c0549"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cda4d99cb786ae2601156afac4d09b53064602b48238fea2b57b5a81b1c96650"
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