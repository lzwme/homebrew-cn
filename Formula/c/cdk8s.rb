class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.46.tgz"
  sha256 "64402eecf08a4073639c4f9dc156c13a61390b9c7190cae36395b27889823207"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ab6d2e6bc0d3c913852041314326e2c31d8508c315fb5a0e3c5da09f1d31152f"
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