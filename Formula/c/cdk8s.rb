class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.155.tgz"
  sha256 "c0658dfba39bb9720ba5d04890fdaa7982bb84db0b447c34f70c25f3f0ea9dde"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dc0156cdf033cc8c008af241ae3cc19a8c637db83fe76e453c22cae54337450a"
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