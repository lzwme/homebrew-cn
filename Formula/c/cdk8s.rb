class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.302.tgz"
  sha256 "226c2f2951af5532541695f5c129a7a927000b9133f85fcc2e83a2ad43b36bef"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed25c45a8b76709c22ff83c7cda3ab66f85c89f423c32f9efa80d5840b4e1f04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed25c45a8b76709c22ff83c7cda3ab66f85c89f423c32f9efa80d5840b4e1f04"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed25c45a8b76709c22ff83c7cda3ab66f85c89f423c32f9efa80d5840b4e1f04"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbe8bfd1f2e2fc804cc4f143a504dbef4fd1a929273ba186bc4823d55b2ed48f"
    sha256 cellar: :any_skip_relocation, ventura:       "cbe8bfd1f2e2fc804cc4f143a504dbef4fd1a929273ba186bc4823d55b2ed48f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed25c45a8b76709c22ff83c7cda3ab66f85c89f423c32f9efa80d5840b4e1f04"
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