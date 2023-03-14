require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.158.tgz"
  sha256 "c3b13b321b266901e71d478b04a309e0808b054c27e53aacdd1d75bdb3dcb2bb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6391df8399d7cf4d55c448f8b0995722b03ca6ad468aba144aefa6be5d845445"
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