class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.202.13.tgz"
  sha256 "6a97c5b2bbac437fbca22c5d1f8d9f74ac4a1a08940b5e84dee9deace9efaf98"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "41a8807f62e98fe01dfbe7e8718dd03969ec88c4731275d1d02a159a53433816"
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