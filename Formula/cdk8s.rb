require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.7.tgz"
  sha256 "9057d53eaef645bfee5094a726b022e564d19dbf40e37b191d04a60ad397735c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0633c7681cf7f46b23a91a1da00d83a2ece1a1b9873291549133b70b68cf1d87"
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