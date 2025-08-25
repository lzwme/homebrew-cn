class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.4.tgz"
  sha256 "7fb8814d0d4a52e3978c1e7037656d05f0ccc8bc021b94536facc31a21616262"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "175e0651f7703a381391339ac7d8c134345439b57e4969cc2c76ad47d9106796"
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