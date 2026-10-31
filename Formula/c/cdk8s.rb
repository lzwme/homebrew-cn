class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.73.tgz"
  sha256 "e4cef19197a7ae65340e208f8acecdc69310ae5264a4a301f1084e3af7753cb8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5b25f1b8e19769355eb72a492d753031bf38dc7a005efa99699426c3e9bf217b"
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