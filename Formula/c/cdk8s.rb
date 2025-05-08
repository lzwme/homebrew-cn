class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.63.tgz"
  sha256 "c8d7ccb427e0bbb636552ab64a76a763ace8330f5f58a7389a33aacf05ce4d51"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "219d5ff58250ccec98b8722ed648f364b0fc1840aafe332cc0d0a2134fab18b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "219d5ff58250ccec98b8722ed648f364b0fc1840aafe332cc0d0a2134fab18b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "219d5ff58250ccec98b8722ed648f364b0fc1840aafe332cc0d0a2134fab18b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "16aa8c4f83580656c1eee66c197bc5d278f69ab5a4b8d292032819d550313367"
    sha256 cellar: :any_skip_relocation, ventura:       "16aa8c4f83580656c1eee66c197bc5d278f69ab5a4b8d292032819d550313367"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "219d5ff58250ccec98b8722ed648f364b0fc1840aafe332cc0d0a2134fab18b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "219d5ff58250ccec98b8722ed648f364b0fc1840aafe332cc0d0a2134fab18b2"
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