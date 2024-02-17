require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.50.tgz"
  sha256 "c699ba65ed246fef050a515318b8521fe00e744e21333e9b6f4270d8d09340ca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d00d12285d1a6bc13af4d3e3cd173f74b24f8f4ade31232391ec43922fb02556"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d00d12285d1a6bc13af4d3e3cd173f74b24f8f4ade31232391ec43922fb02556"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d00d12285d1a6bc13af4d3e3cd173f74b24f8f4ade31232391ec43922fb02556"
    sha256 cellar: :any_skip_relocation, sonoma:         "a38bef213f14452cc01a7f826a28d3b4aaf4c4af873bd24bda86cf939f27e36b"
    sha256 cellar: :any_skip_relocation, ventura:        "a38bef213f14452cc01a7f826a28d3b4aaf4c4af873bd24bda86cf939f27e36b"
    sha256 cellar: :any_skip_relocation, monterey:       "a38bef213f14452cc01a7f826a28d3b4aaf4c4af873bd24bda86cf939f27e36b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d00d12285d1a6bc13af4d3e3cd173f74b24f8f4ade31232391ec43922fb02556"
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