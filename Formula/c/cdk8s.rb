class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.0.tgz"
  sha256 "5ee24c9eb481cd6f02c116c794fcfc0c7ea192722de83e39f55e68aa335e341d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c27e60d171a103a51d998d7f39c61596e5457ef59b40c04a9c29c9fb4d134523"
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