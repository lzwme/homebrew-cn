class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.202.3.tgz"
  sha256 "ea6821e34ccaa699be08b34d538dc8200c62600609fb955d0b19974f781176d9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dba0f51a59169266051b2a34ebf8daa834a635be96fa7cb3ddc4adab906dc4ed"
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