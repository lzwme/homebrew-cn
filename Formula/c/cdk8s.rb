class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.278.tgz"
  sha256 "ebed9194d1df934f61862eb75a32379c4bb34ed76df7f2270ec03f288bf70c60"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ecfa34b5faa81c9a4e9daeb237e29765566a1f56915a1224587b5eb2225fb93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ecfa34b5faa81c9a4e9daeb237e29765566a1f56915a1224587b5eb2225fb93"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ecfa34b5faa81c9a4e9daeb237e29765566a1f56915a1224587b5eb2225fb93"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7851ce00e3105580fff137c6d463f7415d11b0d60813e9905b6bfa62337fdbd"
    sha256 cellar: :any_skip_relocation, ventura:       "b7851ce00e3105580fff137c6d463f7415d11b0d60813e9905b6bfa62337fdbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ecfa34b5faa81c9a4e9daeb237e29765566a1f56915a1224587b5eb2225fb93"
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