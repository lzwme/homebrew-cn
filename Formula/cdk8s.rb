require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.69.tgz"
  sha256 "2c235ba08877a4b78201bc4d189dd3d2cac7edd02aebe1ed80366cc9927c58f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73489332aaf2b6a4316df97d1329f5aa362727d64e72f05be11957e7f009bfee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73489332aaf2b6a4316df97d1329f5aa362727d64e72f05be11957e7f009bfee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73489332aaf2b6a4316df97d1329f5aa362727d64e72f05be11957e7f009bfee"
    sha256 cellar: :any_skip_relocation, ventura:        "6d256173ecfbb806814b6a3ac6092f16003b10ce2786a6e08d24d97b59bad3ae"
    sha256 cellar: :any_skip_relocation, monterey:       "6d256173ecfbb806814b6a3ac6092f16003b10ce2786a6e08d24d97b59bad3ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d256173ecfbb806814b6a3ac6092f16003b10ce2786a6e08d24d97b59bad3ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73489332aaf2b6a4316df97d1329f5aa362727d64e72f05be11957e7f009bfee"
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