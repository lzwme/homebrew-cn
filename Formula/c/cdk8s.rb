class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.48.tgz"
  sha256 "3f8116f2b1926a0da1bb1bc1e8e19061e6b6616e999ec28387605c51c48a5d9e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7ad3e04de72fa99dd2324d6db2f8eb70066a9e2c305c9e7d3f342944405f118c"
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