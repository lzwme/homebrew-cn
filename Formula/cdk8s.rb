require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.48.tgz"
  sha256 "f07fe0d1db54852b6399d5f630f917d03c04d48529eb34d3e872b9bc4bd3cd6d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "edf75ad39c27ac16ce64ff710a8deedf6a57489860551b974fefa0fc52f39410"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edf75ad39c27ac16ce64ff710a8deedf6a57489860551b974fefa0fc52f39410"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "edf75ad39c27ac16ce64ff710a8deedf6a57489860551b974fefa0fc52f39410"
    sha256 cellar: :any_skip_relocation, ventura:        "90ab52a54e765b551a409155cfa2483b8a0fbacee5f3c5aa4779a9ddd333db87"
    sha256 cellar: :any_skip_relocation, monterey:       "90ab52a54e765b551a409155cfa2483b8a0fbacee5f3c5aa4779a9ddd333db87"
    sha256 cellar: :any_skip_relocation, big_sur:        "90ab52a54e765b551a409155cfa2483b8a0fbacee5f3c5aa4779a9ddd333db87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edf75ad39c27ac16ce64ff710a8deedf6a57489860551b974fefa0fc52f39410"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end