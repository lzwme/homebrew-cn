class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.156.tgz"
  sha256 "30f89dde99ffb2ebe6855d85356df56ffe9b050dc127277b0f5336686b82b612"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "38a2ea2ef54fddc78826e254d25d1f72264ce2a34f66e277339a97fda9fcb469"
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