class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.45.tgz"
  sha256 "40f4d8de164a78fbd9942276c9f009698448888b2c03189cfc767c8cfb5358ef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e67df5be1f3c849e331d7401bd83006e36e2fb92d16085ac91885cd0c68db649"
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