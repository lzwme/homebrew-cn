class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.1.tgz"
  sha256 "822f02a76e6d8c2c0a7d0ab470f1b2b87c863b52e83dc9c55206e5f89aa916a4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "77b52ac9f626eee04c502a317e9a636a5bee283c91c66aef7e06cfc1742257b3"
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