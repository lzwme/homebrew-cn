class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.15.tgz"
  sha256 "1f614899ef526568873f37ebd2ad572d815d34d181d72914f8fdbb3f12207a84"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "614f332b412041166ea429025cb48a4b5ab16c9e89ebfd7c07ae13d94713208a"
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