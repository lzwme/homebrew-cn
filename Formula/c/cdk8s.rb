require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.131.tgz"
  sha256 "135ba0433354c85fedd6b415f363300df39b4f81ee983ef8b8fdf1235debc990"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34d2ef1e17ca8d6fe6f33d7a7dccf68151dcdee6149c48c6fe83d7d569b067a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34d2ef1e17ca8d6fe6f33d7a7dccf68151dcdee6149c48c6fe83d7d569b067a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34d2ef1e17ca8d6fe6f33d7a7dccf68151dcdee6149c48c6fe83d7d569b067a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "86f245d7b4fd6ae93eb66a8e96a85a6aec8ddc4dc581b104077346e2dff3a4b0"
    sha256 cellar: :any_skip_relocation, ventura:        "86f245d7b4fd6ae93eb66a8e96a85a6aec8ddc4dc581b104077346e2dff3a4b0"
    sha256 cellar: :any_skip_relocation, monterey:       "86f245d7b4fd6ae93eb66a8e96a85a6aec8ddc4dc581b104077346e2dff3a4b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f17a1518ebfd894e174f85482911ac0b5ec331c59ccc6ba61e3862789580bf62"
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