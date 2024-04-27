require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.105.tgz"
  sha256 "0aa0b912f0cb2274c2e973cecee7eeade71076722cb7da6e45bccda20835824d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d059b4322a2fcc0e4de1ff3508442a30e7123c6fb996292892e6c6a895489954"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d059b4322a2fcc0e4de1ff3508442a30e7123c6fb996292892e6c6a895489954"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d059b4322a2fcc0e4de1ff3508442a30e7123c6fb996292892e6c6a895489954"
    sha256 cellar: :any_skip_relocation, sonoma:         "46c76662b98f436859efe1f7cbec8c6c7d09476756eef9e459cce3269f7b520a"
    sha256 cellar: :any_skip_relocation, ventura:        "46c76662b98f436859efe1f7cbec8c6c7d09476756eef9e459cce3269f7b520a"
    sha256 cellar: :any_skip_relocation, monterey:       "46c76662b98f436859efe1f7cbec8c6c7d09476756eef9e459cce3269f7b520a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d059b4322a2fcc0e4de1ff3508442a30e7123c6fb996292892e6c6a895489954"
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