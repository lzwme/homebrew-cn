require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.116.tgz"
  sha256 "92a03c4503255f641d47ccf34ca97fa25c5943fbd9343b0893e5a4e0fd1a7df9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e3c477ecf80488d5a173f043367392dfb4a097f279b4c43982cdee3b0e41ba0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ac7beb0536a5c03d497a4edf6a18d5610f9387299f7b48eb2e005ec55e1a91a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae7ddcbaae6b879d4eebb211e7b8eb1d9efa47ce43e9439581c8708f888925f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec75113f14a0e1207f02480002fb2516b321be7a264e63068abe6e1febfd2c4b"
    sha256 cellar: :any_skip_relocation, ventura:        "4c86a5fc1aa69a4295d7626fb7feed614d6cec9b53c8ecf0c9f3e743467d34c7"
    sha256 cellar: :any_skip_relocation, monterey:       "553f4063aadd0d4f88ce52306a9ec18e5b1d084566a63d125f56c314c880c5f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1ce41c52aff5ba1a0d4ee595c954e7a3b1c4a9dc097b56e09f1fb95be7f39d9"
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