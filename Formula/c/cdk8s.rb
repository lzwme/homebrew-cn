class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.24.tgz"
  sha256 "e647cdf9cdab6eeb366770250b4b18d46e5e2b38096711016f8614e5d1b5c7a3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "edcaad26de3f93549e686986df2db2cbf84786f3c9e842f07a1763cc58b640c4"
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