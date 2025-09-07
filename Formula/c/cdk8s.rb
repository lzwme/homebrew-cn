class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.17.tgz"
  sha256 "31c44ae07fcf44f1fdbc9ecedbd9cd96299226bc6ae58079fb23dd14fc80731b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7e42a92fdeba4badc3d3b3e2993e940499cb37c2945867ec5622aa6f64ea908f"
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