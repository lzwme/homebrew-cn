require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.103.tgz"
  sha256 "68e7adfdb69714ab5a3beec859963bd608492407538198f1100ea7fc6c8040fb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6c66e77a641d0e7d62158fda64718bde028182305bc1f269085c0399eb08e2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6c66e77a641d0e7d62158fda64718bde028182305bc1f269085c0399eb08e2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6c66e77a641d0e7d62158fda64718bde028182305bc1f269085c0399eb08e2f"
    sha256 cellar: :any_skip_relocation, ventura:        "9faeb8f01e9c6b51892cfa67438358bf56474f3ec78c2982b051f73bd86cafe3"
    sha256 cellar: :any_skip_relocation, monterey:       "9faeb8f01e9c6b51892cfa67438358bf56474f3ec78c2982b051f73bd86cafe3"
    sha256 cellar: :any_skip_relocation, big_sur:        "9faeb8f01e9c6b51892cfa67438358bf56474f3ec78c2982b051f73bd86cafe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6c66e77a641d0e7d62158fda64718bde028182305bc1f269085c0399eb08e2f"
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