class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.12.tgz"
  sha256 "b2b94989e698fd9bdc6beb400ee17671f48c0a00b59279cefa8d4259ebc4b5ea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ca579b55054282ea398254a6dc1b2d86a47a79312f435943cd5a82949ce98101"
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