class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.34.tgz"
  sha256 "7d25028f3a8232558da760d9502648a3396cf83be467274c741927f41ec3af5d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "235b1bbf45957a57bd96758048b10a7b5412f563743cb993c5c78c37498dba6a"
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