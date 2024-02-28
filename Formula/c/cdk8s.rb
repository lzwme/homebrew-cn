require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.58.tgz"
  sha256 "f36985cba5446a678d8925f6b93c7e81073d78d46eca8a0b6f7e62c13545050a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e44984fa2f1dd78c1388aab07ef79dff1b36d66ca9c5a58f7c0ba9e6ca330b75"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e44984fa2f1dd78c1388aab07ef79dff1b36d66ca9c5a58f7c0ba9e6ca330b75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e44984fa2f1dd78c1388aab07ef79dff1b36d66ca9c5a58f7c0ba9e6ca330b75"
    sha256 cellar: :any_skip_relocation, sonoma:         "b83c794b478a4b3398db0c4753e260979ba9f20144402de61588d070e678d7ca"
    sha256 cellar: :any_skip_relocation, ventura:        "b83c794b478a4b3398db0c4753e260979ba9f20144402de61588d070e678d7ca"
    sha256 cellar: :any_skip_relocation, monterey:       "b83c794b478a4b3398db0c4753e260979ba9f20144402de61588d070e678d7ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e44984fa2f1dd78c1388aab07ef79dff1b36d66ca9c5a58f7c0ba9e6ca330b75"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end