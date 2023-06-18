require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.62.tgz"
  sha256 "819bcd4e83387b741eff904926c1e235b01e1d1131ada4efdfeb44fc65d8b028"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f4813d569fd5488586aaf0410824b1a12bb6009c31f229a483e5324d237a072"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f4813d569fd5488586aaf0410824b1a12bb6009c31f229a483e5324d237a072"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f4813d569fd5488586aaf0410824b1a12bb6009c31f229a483e5324d237a072"
    sha256 cellar: :any_skip_relocation, ventura:        "17e88b63ad6703d656da233298393bd98836f348b22deb72ef88184f822f816a"
    sha256 cellar: :any_skip_relocation, monterey:       "17e88b63ad6703d656da233298393bd98836f348b22deb72ef88184f822f816a"
    sha256 cellar: :any_skip_relocation, big_sur:        "17e88b63ad6703d656da233298393bd98836f348b22deb72ef88184f822f816a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f4813d569fd5488586aaf0410824b1a12bb6009c31f229a483e5324d237a072"
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