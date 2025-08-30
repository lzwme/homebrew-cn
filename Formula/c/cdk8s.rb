class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.9.tgz"
  sha256 "e3fbd1d41880884e0e8b34183e3c814c3c83f355d8d7bf5a792e387c74505273"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1156309718362e19ef7eccf62670bf029d93a3bd06afc91f03f1872550d79780"
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