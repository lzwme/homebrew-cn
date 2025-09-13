class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.23.tgz"
  sha256 "9359700180ddab09c689fbcbc14d314061b401244cedf8dd3487334be48e175e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "497311fb82876858590e70e72cda3b77d4f520b0b0dc01a001f67738ccdbe248"
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