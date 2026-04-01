class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.205.6.tgz"
  sha256 "c49cc0aa237188c8a511f2dfef9c3b4b795e95dc9ec68ed2e4ead28861a660cd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9e812f21ea60fe4886b05866c0f7fc3994a7f020e8134a95a4f346b730c618e9"
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