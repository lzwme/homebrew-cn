class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.205.4.tgz"
  sha256 "e420f02f99042fd641553c7c50ed765ad16ca853a31ede748cdadf03aed780da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9147fe9515944a353c2dc29a6fd2dafbb1c6089c62672a5bb58f9ead72453ae0"
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