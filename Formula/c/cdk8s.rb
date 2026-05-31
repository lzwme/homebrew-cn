class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.11.tgz"
  sha256 "01c1b389f523e1ef066cbe86ea1b43367bbe4c559ec6d22215998e8ea569883a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d7569725ef5286eabbba565566da86c99a66e68b334933eae9d188f15552c294"
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