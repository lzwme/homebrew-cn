require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.105.0.tgz"
  sha256 "33c8dd50b7c365d8a603467d64908b913ddefc6f1c610d45479ad3c427226ad0"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64d36310fca8ba323dbaad4272ed4019f7ee5ba55e4f36abf336b21cb79d8c38"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64d36310fca8ba323dbaad4272ed4019f7ee5ba55e4f36abf336b21cb79d8c38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64d36310fca8ba323dbaad4272ed4019f7ee5ba55e4f36abf336b21cb79d8c38"
    sha256 cellar: :any_skip_relocation, sonoma:         "b242f0aea1f357edfabe66beb53f1ad7e674d0ca0c48f7c2e539a837eb64b091"
    sha256 cellar: :any_skip_relocation, ventura:        "b242f0aea1f357edfabe66beb53f1ad7e674d0ca0c48f7c2e539a837eb64b091"
    sha256 cellar: :any_skip_relocation, monterey:       "d3d25c21dfc699d6c921ca366b06e487fe0b05e5c5f6aeac7039f6cec4810df3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64d36310fca8ba323dbaad4272ed4019f7ee5ba55e4f36abf336b21cb79d8c38"
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