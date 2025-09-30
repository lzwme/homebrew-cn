class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.39.tgz"
  sha256 "6f3254cfae386cb641d4bad4e785c922360abc2551161fb233dfdee390ae923b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4752690dd6122b5b66a49e8cc19adeeba3982a443088bfb48bf2480f20739f0e"
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