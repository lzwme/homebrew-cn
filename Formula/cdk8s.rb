require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.3.tgz"
  sha256 "87bb83e93ee0ff6606945d93bf28a588796a682d8e8cbae74cbd77f61e3ff6b6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8e17064323c5a48e7511561570391a858df35b55fbb91b474cf19d3d0cbcf3bc"
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