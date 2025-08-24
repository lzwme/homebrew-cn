class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.3.tgz"
  sha256 "6f4961c44698651327c3a55b8f429d35ec259d9af5800a57220acc61437695ac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4db1bab005415e940846729c78194c7144b3d28139b57662d7f252fc70b544cc"
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