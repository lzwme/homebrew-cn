require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.41.tgz"
  sha256 "efc654be946c570b98c7a9970a49a3b90aa426ae943071c34bce03c89eba6843"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59d6d2caa526359866a1ceca5787816ba2d9707909b213a0f735ced7a51c2ebe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59d6d2caa526359866a1ceca5787816ba2d9707909b213a0f735ced7a51c2ebe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59d6d2caa526359866a1ceca5787816ba2d9707909b213a0f735ced7a51c2ebe"
    sha256 cellar: :any_skip_relocation, ventura:        "933e2a5eb9a34d870ab95370af761df6de4a335e64151a3a57d854bb9cd4d1d0"
    sha256 cellar: :any_skip_relocation, monterey:       "933e2a5eb9a34d870ab95370af761df6de4a335e64151a3a57d854bb9cd4d1d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "933e2a5eb9a34d870ab95370af761df6de4a335e64151a3a57d854bb9cd4d1d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59d6d2caa526359866a1ceca5787816ba2d9707909b213a0f735ced7a51c2ebe"
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