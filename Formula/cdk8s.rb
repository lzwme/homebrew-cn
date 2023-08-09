require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.27.0.tgz"
  sha256 "41d53db1e8965cec3ca7df5e977bec794a29c7fc9dcd6f1a3b5543298b00c2b8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2ed979bec596b8f67208cfb4620a301a0852f204398497f8c27d7fb6a802ade"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2ed979bec596b8f67208cfb4620a301a0852f204398497f8c27d7fb6a802ade"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2ed979bec596b8f67208cfb4620a301a0852f204398497f8c27d7fb6a802ade"
    sha256 cellar: :any_skip_relocation, ventura:        "e6f5a562077fe9f3ed1c416b1bb5ba0919717c573eed10384ba97fcb93ed4ca5"
    sha256 cellar: :any_skip_relocation, monterey:       "e6f5a562077fe9f3ed1c416b1bb5ba0919717c573eed10384ba97fcb93ed4ca5"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6f5a562077fe9f3ed1c416b1bb5ba0919717c573eed10384ba97fcb93ed4ca5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2ed979bec596b8f67208cfb4620a301a0852f204398497f8c27d7fb6a802ade"
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