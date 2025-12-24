class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.203.13.tgz"
  sha256 "6dc3dc6206ce4b7576068c3ac574ccc77f6488ee2c4d508c0d0461759445c1ee"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "29048ebc122a0ba89465c413b300917ac8cd670e039a298d742b382e592d3a8a"
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