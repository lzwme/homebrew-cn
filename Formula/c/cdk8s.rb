class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.7.tgz"
  sha256 "d93e184c58d3d81aafce693e9e25930695d39ba502dc1d60e30f63aa0dd4f16a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4b722684315731e30ee17344373b3cf9ed2290b63dda8a1ab1d5508246004e52"
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