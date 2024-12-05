class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.273.tgz"
  sha256 "0ea4c93a0a49b857278a854c821a6acdff31d72ebfcb19a7f4c757d2d642767f"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a22a38f0a88ee1986e6bfe810050c83e6815def5b397cd60cc443a83447c82dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a22a38f0a88ee1986e6bfe810050c83e6815def5b397cd60cc443a83447c82dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a22a38f0a88ee1986e6bfe810050c83e6815def5b397cd60cc443a83447c82dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "55693091a005d664d1f9c5b1b6be675c6b8064652c7c64d0f9274e90c71ccbf6"
    sha256 cellar: :any_skip_relocation, ventura:       "55693091a005d664d1f9c5b1b6be675c6b8064652c7c64d0f9274e90c71ccbf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a22a38f0a88ee1986e6bfe810050c83e6815def5b397cd60cc443a83447c82dc"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    output = shell_output("#{bin}cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end