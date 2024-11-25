class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.268.tgz"
  sha256 "834536642fc253a02cc6392176ba7f584685548dc9a56122dabb6eb62f1f4f97"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5de9856ed23e14f4827451a28c12efbe553abbdbc389890d7f88db6778986fbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5de9856ed23e14f4827451a28c12efbe553abbdbc389890d7f88db6778986fbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5de9856ed23e14f4827451a28c12efbe553abbdbc389890d7f88db6778986fbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1accf9fd7e3cae31a54d0cdff66688b77694c610b4ad733146c6df06ae396ee"
    sha256 cellar: :any_skip_relocation, ventura:       "a1accf9fd7e3cae31a54d0cdff66688b77694c610b4ad733146c6df06ae396ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5de9856ed23e14f4827451a28c12efbe553abbdbc389890d7f88db6778986fbd"
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