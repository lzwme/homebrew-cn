class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.203.16.tgz"
  sha256 "d1828545b8947841201e01627bb30b9b830ae8e97f76a0738411fa3f81f7b6fc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "737da2532d46781cbc04f14455cd19073eee73a7b1b8fcb2f5d83fd18a5bd842"
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