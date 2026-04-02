class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.206.0.tgz"
  sha256 "ac20a044845f4ee7bd8640896d114a4c837528b1a6bac9a4bd859239280a2fbc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fc3b0328e57a172d55d99a3c1aa1e3ca3c0e6ca40041d55d19077fe9ab84345d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end