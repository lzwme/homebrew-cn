class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.203.8.tgz"
  sha256 "e8189793c90b7f3d36f8ce6c48bd1154d9bdf7988c38258dde4291eaf3836c2a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b6a4916b57cf5b49c6d1cd6fca5814bb2ebc69b50dc8e475279020ac632de577"
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