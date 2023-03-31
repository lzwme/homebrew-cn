require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.6.tgz"
  sha256 "5686f996339e2caab9c5f8fc8fa78ed9319e14c890baab7ee450e3c97e7ad6ac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "90fbb04ac2ad0055431b8dbc8494f73de2e25c47d60bef6430220d770a34bd3d"
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