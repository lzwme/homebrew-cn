class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.202.0.tgz"
  sha256 "8c301ecf5b9747427a463f17d5b7f4a8e6bf3c0e72ff09802b902981be10cb72"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "639a8c943d032323a12482028c79a96b15071b4f52a766e90cfcbf4f07776a94"
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