class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.72.tgz"
  sha256 "509b482ddf9ef498744065336e5b647b14bea7a333a40ceb5633e0a5c49efd98"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "92412b1b5e77770043f569075f9110e92bc6543cdc2e93119b54ef80b6451d1c"
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