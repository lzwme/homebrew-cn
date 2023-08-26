require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.57.0.tgz"
  sha256 "68c9e0345683f34b5fdaab871420160a89cc249f2303faf78d19f62af545dc5f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83c29a3eb2005e12f00b251a2378ed4096b4a1e4d37d936a5d24cb3ca4192eb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83c29a3eb2005e12f00b251a2378ed4096b4a1e4d37d936a5d24cb3ca4192eb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83c29a3eb2005e12f00b251a2378ed4096b4a1e4d37d936a5d24cb3ca4192eb0"
    sha256 cellar: :any_skip_relocation, ventura:        "63949e0d3c35bca712d43d55a661fe968aecb65b2d43d64cdfed86042fc8c058"
    sha256 cellar: :any_skip_relocation, monterey:       "63949e0d3c35bca712d43d55a661fe968aecb65b2d43d64cdfed86042fc8c058"
    sha256 cellar: :any_skip_relocation, big_sur:        "63949e0d3c35bca712d43d55a661fe968aecb65b2d43d64cdfed86042fc8c058"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83c29a3eb2005e12f00b251a2378ed4096b4a1e4d37d936a5d24cb3ca4192eb0"
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