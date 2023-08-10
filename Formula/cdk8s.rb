require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.29.0.tgz"
  sha256 "4a3e529edf70cb31a12d1e897b0ac6d5f3f5623affbb7ed680d3bc9d5ba93441"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d726950d6d7cc28f827d1c6f5943e79d87a769e24a258045ec9cc493d054e459"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d726950d6d7cc28f827d1c6f5943e79d87a769e24a258045ec9cc493d054e459"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d726950d6d7cc28f827d1c6f5943e79d87a769e24a258045ec9cc493d054e459"
    sha256 cellar: :any_skip_relocation, ventura:        "7bc96aa6b77feb0c84cab94a53debf963ae31a4b5c726af7cc2fa13d7f8b7411"
    sha256 cellar: :any_skip_relocation, monterey:       "7bc96aa6b77feb0c84cab94a53debf963ae31a4b5c726af7cc2fa13d7f8b7411"
    sha256 cellar: :any_skip_relocation, big_sur:        "7bc96aa6b77feb0c84cab94a53debf963ae31a4b5c726af7cc2fa13d7f8b7411"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d726950d6d7cc28f827d1c6f5943e79d87a769e24a258045ec9cc493d054e459"
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