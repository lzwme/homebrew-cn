require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.166.tgz"
  sha256 "55efe58d57e0ee734f1d6b830080d48ea04363f9fcef3b26b3630e7b107c22cf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d95c4a933b854c620ecbead2fc23d05b981c52cf3cfab72b1f3a422b67c40c77"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d95c4a933b854c620ecbead2fc23d05b981c52cf3cfab72b1f3a422b67c40c77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d95c4a933b854c620ecbead2fc23d05b981c52cf3cfab72b1f3a422b67c40c77"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ba6b76e8517dc62ca62057d3ad902ffb75aa8ed708266ccf555293b408848be"
    sha256 cellar: :any_skip_relocation, ventura:        "4ba6b76e8517dc62ca62057d3ad902ffb75aa8ed708266ccf555293b408848be"
    sha256 cellar: :any_skip_relocation, monterey:       "4ba6b76e8517dc62ca62057d3ad902ffb75aa8ed708266ccf555293b408848be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d89059ea99d0dd23e086f7e7ebe8eaf5d7803483fdb2aa2d31448fd289764f5"
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