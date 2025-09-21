class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.31.tgz"
  sha256 "b291932c020ea2c4202292e8958fe7298ca533aaaaa4f70a11f8cd5a5a83627d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ed8b7bc519c8f4c7e5f61e61d63482b346c29f6611877b152d1322fe7f86f427"
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