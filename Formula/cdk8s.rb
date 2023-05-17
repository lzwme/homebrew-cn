require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.35.tgz"
  sha256 "d502b493cf774e298f51061a46947d4c87828770296ff28683f9e5247a98b013"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0fba11d18de6329fdea1500a91d20230b742ea5f35fc046282ad25719818b75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0fba11d18de6329fdea1500a91d20230b742ea5f35fc046282ad25719818b75"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2093e3b8dbb74bc6f4df4ec82a09fdaf65c688ad8c04dea7646abf0b078fe85"
    sha256 cellar: :any_skip_relocation, ventura:        "2f6935562c137e00ec3b55f48b7a2b075ff768fa4d8ce2885245c0b2784a8725"
    sha256 cellar: :any_skip_relocation, monterey:       "2f6935562c137e00ec3b55f48b7a2b075ff768fa4d8ce2885245c0b2784a8725"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f6935562c137e00ec3b55f48b7a2b075ff768fa4d8ce2885245c0b2784a8725"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0fba11d18de6329fdea1500a91d20230b742ea5f35fc046282ad25719818b75"
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