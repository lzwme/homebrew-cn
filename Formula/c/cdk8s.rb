class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.205.0.tgz"
  sha256 "1a81754d0d647c17b38d18fe9272670dd26b065aa428ba70d1b501ecd16f586a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "660226b481cf13b7d6e5750e3a8a039060e7648e2b2d76df77766fd73a81f58d"
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