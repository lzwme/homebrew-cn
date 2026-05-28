class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.9.tgz"
  sha256 "16cc6a05430baad1d3e6237b42b0525001ea989ae60ab19ed227d7655091fc94"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a74bd6d660933d0999c0b52d56123deb07492a0c7ebb2ab66690196af33144ae"
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