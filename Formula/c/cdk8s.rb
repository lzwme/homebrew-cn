class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.25.tgz"
  sha256 "d16d35f08118bb415691311049c23c53e19005a64869008d3009f4495582b6d5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "03d48c17db376215cec4be244f62c37137385194a2bfe9417dc4be667123cf55"
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