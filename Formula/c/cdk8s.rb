class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.92.tgz"
  sha256 "f6dc500c7b5ea5877fd6daa597ce934da44f4cfb720e51824ea6bdde55695083"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f66b54204be6ae94e4e1d0462cdc8b8b9a8c8e246b0e4f13b3b9824b4f72a6b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f66b54204be6ae94e4e1d0462cdc8b8b9a8c8e246b0e4f13b3b9824b4f72a6b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f66b54204be6ae94e4e1d0462cdc8b8b9a8c8e246b0e4f13b3b9824b4f72a6b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4d2e39096fff4f82fce847f5af073fac89714c3692df7d81b08378e8c5a5ae7"
    sha256 cellar: :any_skip_relocation, ventura:       "a4d2e39096fff4f82fce847f5af073fac89714c3692df7d81b08378e8c5a5ae7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f66b54204be6ae94e4e1d0462cdc8b8b9a8c8e246b0e4f13b3b9824b4f72a6b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f66b54204be6ae94e4e1d0462cdc8b8b9a8c8e246b0e4f13b3b9824b4f72a6b9"
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