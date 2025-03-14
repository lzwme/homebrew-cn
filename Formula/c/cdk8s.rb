class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.16.tgz"
  sha256 "c0f6b87d06d3ba4d4bbc9264d8e1c547ab5c3203afbfe53c21a6971933dfa645"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7481efe4dbd7f3b2a260afe0978dc6607775327b294ae5c6f608813613b158b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7481efe4dbd7f3b2a260afe0978dc6607775327b294ae5c6f608813613b158b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7481efe4dbd7f3b2a260afe0978dc6607775327b294ae5c6f608813613b158b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "13a783127dd6c72da4eba08693d164cd368e1565eb970269a4321a84c0f69993"
    sha256 cellar: :any_skip_relocation, ventura:       "13a783127dd6c72da4eba08693d164cd368e1565eb970269a4321a84c0f69993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7481efe4dbd7f3b2a260afe0978dc6607775327b294ae5c6f608813613b158b4"
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