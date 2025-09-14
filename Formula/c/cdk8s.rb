class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.24.tgz"
  sha256 "d68b6f58b0176845be87b5eabbd42de9ad9eae69e5c492bb10c604082f577828"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "15785a14900d36abd306ff1719b3ad0ceead25e24c76681cbba8253ca90ad628"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end