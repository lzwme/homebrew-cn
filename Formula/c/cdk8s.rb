class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.203.12.tgz"
  sha256 "4dd6064eec949ff2b9b70028d06e6edb60d377dcdaeec23c234b110b9995b02b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5cc0daea5bcc35f2bfcb74ee26d8624b1d5841cf5e638029009926c8e38ba735"
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