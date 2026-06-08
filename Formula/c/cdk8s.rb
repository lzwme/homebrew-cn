class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.17.tgz"
  sha256 "b8646901817ba21818300ae1c9bd103952e38cbf0768830616ab56f9837e8e13"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a0d3338d911d3779a72657949554dc87ca9698e52a4ebcc02602b08eee8295ce"
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