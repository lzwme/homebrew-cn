require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.128.tgz"
  sha256 "8358fafd94e3c418c61c15ce596cea5da989921a539aae25fbb03381fd2fcb78"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6dc63ed1f443e7e0d97d8db5d2698fdb560566be49bf5a77defd9e1c465c8ad2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1056f81d627eff09fa514f447075cd0708aa1c2d036c9577cff7c7c25b9eb17a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "300f2a9ec94a019cd15459307e57e5e56a3ef5444be301215c40679eb71a7ec5"
    sha256 cellar: :any_skip_relocation, sonoma:         "93a5d05be94d47436067e25bb4f9a97fb9b37c976ac3ca81fbfd61c5d30b95c1"
    sha256 cellar: :any_skip_relocation, ventura:        "dd1a4c6cd236389ad1036a946405f8bd1952393421f53e73cc3f7f26c24c6031"
    sha256 cellar: :any_skip_relocation, monterey:       "ab0777a6626b2d305af3d8761ad7a95955108d3417385015fec94e2600a27912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9c20a1c316cb90055bb3684dd8d4a25d1b69629dcf2f3d7b02083b2668f0799"
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