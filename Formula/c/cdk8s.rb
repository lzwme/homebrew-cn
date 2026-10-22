class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.69.tgz"
  sha256 "976ed788dfa415e68ae07ec09895a5946389fc8bf3eba63600345e5b5425e52b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c1ff484c370be90fbb05abc0c5d932d199cd27dfe2c85cb217dfae4d26dc8682"
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