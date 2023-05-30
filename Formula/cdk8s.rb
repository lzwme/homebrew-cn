require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.46.tgz"
  sha256 "21cece8d0196027deef195ce295dfebc1962e42cdc3ff7be7c75ad4842b7081c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1720b8cd1579da853db3a2df40f140aff0ed7cf2019b9ee25b6d7e1f6c7f056"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1720b8cd1579da853db3a2df40f140aff0ed7cf2019b9ee25b6d7e1f6c7f056"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1720b8cd1579da853db3a2df40f140aff0ed7cf2019b9ee25b6d7e1f6c7f056"
    sha256 cellar: :any_skip_relocation, ventura:        "568136f511a06b825c070ea5a1abb86510e3025c2778cabf88ff5c7f16f071d7"
    sha256 cellar: :any_skip_relocation, monterey:       "568136f511a06b825c070ea5a1abb86510e3025c2778cabf88ff5c7f16f071d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "568136f511a06b825c070ea5a1abb86510e3025c2778cabf88ff5c7f16f071d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1720b8cd1579da853db3a2df40f140aff0ed7cf2019b9ee25b6d7e1f6c7f056"
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