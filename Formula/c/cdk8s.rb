require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.146.0.tgz"
  sha256 "29905e8512cf4bb4d080fb0b50b1db0e80577ed6d5302d7ff4e847b049fafaaf"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0af4648664da0fc54e9ef443d586dbcad00e74aff78b4d2a15bfe6d76197e436"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0af4648664da0fc54e9ef443d586dbcad00e74aff78b4d2a15bfe6d76197e436"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0af4648664da0fc54e9ef443d586dbcad00e74aff78b4d2a15bfe6d76197e436"
    sha256 cellar: :any_skip_relocation, sonoma:         "d53e28213ea167c7acc84d7c2ce5ef75ed9f67c96460bdc33359db48b348927c"
    sha256 cellar: :any_skip_relocation, ventura:        "d53e28213ea167c7acc84d7c2ce5ef75ed9f67c96460bdc33359db48b348927c"
    sha256 cellar: :any_skip_relocation, monterey:       "d53e28213ea167c7acc84d7c2ce5ef75ed9f67c96460bdc33359db48b348927c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0af4648664da0fc54e9ef443d586dbcad00e74aff78b4d2a15bfe6d76197e436"
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