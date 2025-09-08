class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.18.tgz"
  sha256 "fa88a76c60cda85a4c6dc264faf69d89207daaa83f0193dd7861433f98f961bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bfcbd49ee6f77d197234706bea67b97bf488678e44075e0c9cbcecd9e13fd4e7"
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