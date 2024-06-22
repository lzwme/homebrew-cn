require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.152.tgz"
  sha256 "d7389e69e96578e9b3e0ad8ae59f7408a0e875da87e96ef39c3fa2fd88acdb80"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28e61a66790d0185daa30e179565af768df5403b95f1fc3d57876fe7cd5a5f22"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28e61a66790d0185daa30e179565af768df5403b95f1fc3d57876fe7cd5a5f22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28e61a66790d0185daa30e179565af768df5403b95f1fc3d57876fe7cd5a5f22"
    sha256 cellar: :any_skip_relocation, sonoma:         "a88f2a648dc4086d698b63c5bec6381285fcc02caafe6fff27ed2c2c949bc000"
    sha256 cellar: :any_skip_relocation, ventura:        "a88f2a648dc4086d698b63c5bec6381285fcc02caafe6fff27ed2c2c949bc000"
    sha256 cellar: :any_skip_relocation, monterey:       "a88f2a648dc4086d698b63c5bec6381285fcc02caafe6fff27ed2c2c949bc000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8da34e24790f4c4202ff0f63ece57b7c10ceddd0fd74b65c30a5fdfcfa3c33ec"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end