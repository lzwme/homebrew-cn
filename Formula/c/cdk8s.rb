class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.323.tgz"
  sha256 "ad7beaa3181de9d10c9fc7bd674fb71e115f47cac25694b243b0fe11de07dae9"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f9da0b5037f6e0b1ba0cfe6e06f66b0a8e0577ca0cd194bd7b595cfba4d2704"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f9da0b5037f6e0b1ba0cfe6e06f66b0a8e0577ca0cd194bd7b595cfba4d2704"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f9da0b5037f6e0b1ba0cfe6e06f66b0a8e0577ca0cd194bd7b595cfba4d2704"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b52312782b70b7ec81e6c7552501be474d2c713c85c54882c760c5bf1805e63"
    sha256 cellar: :any_skip_relocation, ventura:       "6b52312782b70b7ec81e6c7552501be474d2c713c85c54882c760c5bf1805e63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f9da0b5037f6e0b1ba0cfe6e06f66b0a8e0577ca0cd194bd7b595cfba4d2704"
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