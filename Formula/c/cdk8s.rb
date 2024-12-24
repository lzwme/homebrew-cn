class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.285.tgz"
  sha256 "e513a55f192c25de7631be1d2800c602128845e710a2c0be543372365e36b786"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfe821f168be58388aa92006d2b253bb25ffd56d9ed7a1df7f3d03f6addeef7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfe821f168be58388aa92006d2b253bb25ffd56d9ed7a1df7f3d03f6addeef7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dfe821f168be58388aa92006d2b253bb25ffd56d9ed7a1df7f3d03f6addeef7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ceeae53eb5de20b1261505400dee36733fb5f651c55f35d83156fb36c30f5701"
    sha256 cellar: :any_skip_relocation, ventura:       "ceeae53eb5de20b1261505400dee36733fb5f651c55f35d83156fb36c30f5701"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfe821f168be58388aa92006d2b253bb25ffd56d9ed7a1df7f3d03f6addeef7f"
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