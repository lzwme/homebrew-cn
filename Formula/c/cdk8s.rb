require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.71.0.tgz"
  sha256 "278a15c5261505aa05a9f87c11d959a16553b4c9d70df8558bd7154de743ef86"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9c74a261f5d09ef8620def81574b123faad6b8b60c186e82d1ec66ad7a50205"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9c74a261f5d09ef8620def81574b123faad6b8b60c186e82d1ec66ad7a50205"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9c74a261f5d09ef8620def81574b123faad6b8b60c186e82d1ec66ad7a50205"
    sha256 cellar: :any_skip_relocation, ventura:        "354eca8df0ca9bceac099b1a3b3a148b4f28efd615e9c5e1bf1f5cd7c2b3f8fb"
    sha256 cellar: :any_skip_relocation, monterey:       "354eca8df0ca9bceac099b1a3b3a148b4f28efd615e9c5e1bf1f5cd7c2b3f8fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "354eca8df0ca9bceac099b1a3b3a148b4f28efd615e9c5e1bf1f5cd7c2b3f8fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9c74a261f5d09ef8620def81574b123faad6b8b60c186e82d1ec66ad7a50205"
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