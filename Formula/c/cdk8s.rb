class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.30.tgz"
  sha256 "daac639c59bd8aef5a31783955f461f647dac445cc321af281ac8dd70801889a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "344fd411a05b997c0a40f8e7be5b4910b4a5721daceb2a45d9baf5be7f286fa4"
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