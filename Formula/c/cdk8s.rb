class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.36.tgz"
  sha256 "7ff9b196eed2f0d679346fd7dc44e6297f50f8be3ae17cf6ac091efac9d4e06c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b2370d464d4d849b5cd3c9d4745a60582661807742d8e5fdb524551ef0fee6ce"
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