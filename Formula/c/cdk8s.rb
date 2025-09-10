class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.20.tgz"
  sha256 "47a5764863353bc773044538a351ad32bf29cbc41dbf35be28170b596163c6b6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7279023110bd7a6a7b89ad20d48179a8c66a5a329173a2084a41d5b4b39af152"
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