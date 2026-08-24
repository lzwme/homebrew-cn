class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.54.tgz"
  sha256 "075615b4351e6176a6966b5a1b98e2ea308adb1d070c6a22ac27ce3f15b86c65"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0c395d180ac4fb6fe03618faab1f4fdac71f67b566cdd95193452d3ab1a17b50"
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