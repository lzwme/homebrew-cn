class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.22.tgz"
  sha256 "b5f65738fc7343deb2bed0d58db882917699892a08e9e3ae2fcc4de7b256d1ad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "306510df0fc67cb8272c23864759aa45c741e3e24aa9c137ced38778f50c4af0"
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