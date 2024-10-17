class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.248.tgz"
  sha256 "315050deeec0917dcfae8ff1a503ce272ff1787c2bb9c4f2059a3123c86766f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09ba2128401bef0e6c53bd0bb125dbb7f7dc41294a590e416f8ae4bb9081b321"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09ba2128401bef0e6c53bd0bb125dbb7f7dc41294a590e416f8ae4bb9081b321"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09ba2128401bef0e6c53bd0bb125dbb7f7dc41294a590e416f8ae4bb9081b321"
    sha256 cellar: :any_skip_relocation, sonoma:        "45902d4e4fabdc4874f0e3b4b9953c5a3a09b8c3f0183a146f785a25c28a39a4"
    sha256 cellar: :any_skip_relocation, ventura:       "45902d4e4fabdc4874f0e3b4b9953c5a3a09b8c3f0183a146f785a25c28a39a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09ba2128401bef0e6c53bd0bb125dbb7f7dc41294a590e416f8ae4bb9081b321"
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