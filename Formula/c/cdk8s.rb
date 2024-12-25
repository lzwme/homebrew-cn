class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.286.tgz"
  sha256 "d181501842759baa7784aee701f83bfc34a743a5ad92ec4bc1c4952c0069b377"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffa9a44b18c66b344201da095b4c7567d495237005bbaa2ee73d20500cef8054"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffa9a44b18c66b344201da095b4c7567d495237005bbaa2ee73d20500cef8054"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ffa9a44b18c66b344201da095b4c7567d495237005bbaa2ee73d20500cef8054"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea561721976f80a337f21a1678c62ff44eed3e61f97fed621fb2220e3dc4c606"
    sha256 cellar: :any_skip_relocation, ventura:       "ea561721976f80a337f21a1678c62ff44eed3e61f97fed621fb2220e3dc4c606"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffa9a44b18c66b344201da095b4c7567d495237005bbaa2ee73d20500cef8054"
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