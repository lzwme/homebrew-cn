class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.27.tgz"
  sha256 "a0d30a59a7cbd26d2fadf6dc9fa48ad25932e064bbf233652189f2b074933362"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fec36d24ba9ee3e73f1363d5e6447a434ade9f6122015257378ef8bedbb2604d"
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