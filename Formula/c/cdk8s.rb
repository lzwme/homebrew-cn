class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.203.10.tgz"
  sha256 "014c7b2cc943d995cf33a4e603372e2485fe5447682fa1c47c41c5f4bbeeca5c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "04926766fadaf49d09ce4bd67d5b448c5b8b2554771fab6a7419bfd7c96c4e90"
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