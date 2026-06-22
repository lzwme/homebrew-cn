class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.25.tgz"
  sha256 "7a0d64e1b23e4276b106167660cfc82dfdbe4faeb232f7358452dc18442b4570"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "10980b978d70b78a7034ea8b208320e05934a8b279ed9db24d561d55d71b9415"
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