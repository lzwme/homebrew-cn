class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.66.tgz"
  sha256 "54010d3d1d21e9392446df7d2aeacbc24c01f12fd4f28eeca25bffe366284ec1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9a7ff1550ccc654cfa40b03cf0efeaef84a5c37ef4752a0af23a395c0fc900e0"
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