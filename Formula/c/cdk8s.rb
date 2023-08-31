require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.66.0.tgz"
  sha256 "5dca994058524e70816233f7dc86667ee721511bf56ab1357d3d4492b81f99b6"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf13fad26ba9c8095c15df715f94a123cf36999107f8fe8408b7cf44fa7c76f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf13fad26ba9c8095c15df715f94a123cf36999107f8fe8408b7cf44fa7c76f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf13fad26ba9c8095c15df715f94a123cf36999107f8fe8408b7cf44fa7c76f9"
    sha256 cellar: :any_skip_relocation, ventura:        "de1966a22d01a4ad81cc41a2319b4f37f17e34091a6bcc957518093607ed5050"
    sha256 cellar: :any_skip_relocation, monterey:       "de1966a22d01a4ad81cc41a2319b4f37f17e34091a6bcc957518093607ed5050"
    sha256 cellar: :any_skip_relocation, big_sur:        "de1966a22d01a4ad81cc41a2319b4f37f17e34091a6bcc957518093607ed5050"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf13fad26ba9c8095c15df715f94a123cf36999107f8fe8408b7cf44fa7c76f9"
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