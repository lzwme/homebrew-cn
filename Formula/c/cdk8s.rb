require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.45.0.tgz"
  sha256 "99eadce10685a021bebf2e93ee83d90d5bf72634fc647b7454fc99d9e0a6d830"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ee70e73adeaed041aca16a011998394605c00ce5a0557e86a4acb21760f4fa8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ee70e73adeaed041aca16a011998394605c00ce5a0557e86a4acb21760f4fa8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ee70e73adeaed041aca16a011998394605c00ce5a0557e86a4acb21760f4fa8"
    sha256 cellar: :any_skip_relocation, ventura:        "60f080c7841de6e78cc1453237cfbbef0a5c8923e528a5829cc8644e92558311"
    sha256 cellar: :any_skip_relocation, monterey:       "60f080c7841de6e78cc1453237cfbbef0a5c8923e528a5829cc8644e92558311"
    sha256 cellar: :any_skip_relocation, big_sur:        "60f080c7841de6e78cc1453237cfbbef0a5c8923e528a5829cc8644e92558311"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ee70e73adeaed041aca16a011998394605c00ce5a0557e86a4acb21760f4fa8"
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