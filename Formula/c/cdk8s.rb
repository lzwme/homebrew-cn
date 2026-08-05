class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.45.tgz"
  sha256 "25978da487d9efc1091b44f8833abe6fd1f633d37a4e4ccf0e65f0293c8ee25c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "69383ab964a34af5ab20de150f4b433989821061f7c40e8de96d1f9569dac2cc"
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