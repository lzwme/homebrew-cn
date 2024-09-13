class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.215.tgz"
  sha256 "c1348f4399455ca534f72e45b9074e305b007a41814075b1dc89c3b04205cef6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3f9dc1c4266d70e4c79e29f95b6bf50b82d1c2bef77914f3c4117bf8a7b97ecf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f9dc1c4266d70e4c79e29f95b6bf50b82d1c2bef77914f3c4117bf8a7b97ecf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f9dc1c4266d70e4c79e29f95b6bf50b82d1c2bef77914f3c4117bf8a7b97ecf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f9dc1c4266d70e4c79e29f95b6bf50b82d1c2bef77914f3c4117bf8a7b97ecf"
    sha256 cellar: :any_skip_relocation, sonoma:         "6adfc4a92bb615ac61e2fa0129c02fc80a14e1b478e1c96454495dc03425b9eb"
    sha256 cellar: :any_skip_relocation, ventura:        "6adfc4a92bb615ac61e2fa0129c02fc80a14e1b478e1c96454495dc03425b9eb"
    sha256 cellar: :any_skip_relocation, monterey:       "6adfc4a92bb615ac61e2fa0129c02fc80a14e1b478e1c96454495dc03425b9eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f9dc1c4266d70e4c79e29f95b6bf50b82d1c2bef77914f3c4117bf8a7b97ecf"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end