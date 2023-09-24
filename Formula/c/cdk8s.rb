require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.99.0.tgz"
  sha256 "43ed5730baf3a82eee74446e1128df8d2c5da29fa38e3bf409eb71c965db608b"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63c06686951494af3974d962fe5ef59251bcac652d2f162996398f8c5c482b5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63c06686951494af3974d962fe5ef59251bcac652d2f162996398f8c5c482b5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63c06686951494af3974d962fe5ef59251bcac652d2f162996398f8c5c482b5f"
    sha256 cellar: :any_skip_relocation, ventura:        "240d89e9b553560d0eb2eef5a44619e74eee18c7d31f293140ad8e7b37541c12"
    sha256 cellar: :any_skip_relocation, monterey:       "240d89e9b553560d0eb2eef5a44619e74eee18c7d31f293140ad8e7b37541c12"
    sha256 cellar: :any_skip_relocation, big_sur:        "240d89e9b553560d0eb2eef5a44619e74eee18c7d31f293140ad8e7b37541c12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63c06686951494af3974d962fe5ef59251bcac652d2f162996398f8c5c482b5f"
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