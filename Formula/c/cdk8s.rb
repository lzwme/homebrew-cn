class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.14.tgz"
  sha256 "870b7da4b992c5d16c5443c66a2e295bc9cf6b4d3569bd882523bf830ae52ee1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f367e2ff1c788469a87776fc05da50aed5a7475384c0fdc287acdbb5edc597e9"
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