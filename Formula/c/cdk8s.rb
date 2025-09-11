class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.21.tgz"
  sha256 "9b6080b99373fea3d67e02064315c6143d0326629b30a7f10d73549cf48666ee"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5f3f8d2e672c0cad79b1d14f7bf704a851e900a6ca87db49cbd3c69b76694057"
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