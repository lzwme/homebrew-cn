require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.159.tgz"
  sha256 "cb63614d58c7fc161d6bc1da8574f206cb66a64555a63214a7e0b38eef154b32"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6b849ca3242067cd400f52259f5765e1d424d0acc205561bd5261511fa8012eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b849ca3242067cd400f52259f5765e1d424d0acc205561bd5261511fa8012eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b849ca3242067cd400f52259f5765e1d424d0acc205561bd5261511fa8012eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "b0502569dd0e6304a485e58009326d44e5c7e9cde906aa97531641f572569b78"
    sha256 cellar: :any_skip_relocation, ventura:        "b0502569dd0e6304a485e58009326d44e5c7e9cde906aa97531641f572569b78"
    sha256 cellar: :any_skip_relocation, monterey:       "b0502569dd0e6304a485e58009326d44e5c7e9cde906aa97531641f572569b78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d22eacaf9b49572e545cde26d5b4e644efdab3eb6985ca0cce2fc2cdeecef758"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end