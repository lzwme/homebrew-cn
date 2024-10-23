class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.253.tgz"
  sha256 "2ffa72871fae94712b21a6e5f52c07b9a77254dda22793ee34d80dbe24dae569"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c98740c5547da990f869e87a6d291e62fe0599505deeeac7f32c3a3a6d177c9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c98740c5547da990f869e87a6d291e62fe0599505deeeac7f32c3a3a6d177c9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c98740c5547da990f869e87a6d291e62fe0599505deeeac7f32c3a3a6d177c9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d3691c3e3167588dc72ece98531d21632cd891e107d49d032b39c6687b20c84"
    sha256 cellar: :any_skip_relocation, ventura:       "7d3691c3e3167588dc72ece98531d21632cd891e107d49d032b39c6687b20c84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c98740c5547da990f869e87a6d291e62fe0599505deeeac7f32c3a3a6d177c9b"
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