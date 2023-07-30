require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.12.0.tgz"
  sha256 "d8c7ee2481872bcff69958eab6168dfb3a3b12532f5b7a921dacdd00f165fe4b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3363b89e84048ce8e9a045e601dbbfa63b1eb47f4f73bf4375084aba5f0df194"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3363b89e84048ce8e9a045e601dbbfa63b1eb47f4f73bf4375084aba5f0df194"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3363b89e84048ce8e9a045e601dbbfa63b1eb47f4f73bf4375084aba5f0df194"
    sha256 cellar: :any_skip_relocation, ventura:        "9b08c76503d5723ab2d8290e76524aca0c9fb557da85e1dbe23846a4bd466be0"
    sha256 cellar: :any_skip_relocation, monterey:       "9b08c76503d5723ab2d8290e76524aca0c9fb557da85e1dbe23846a4bd466be0"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b08c76503d5723ab2d8290e76524aca0c9fb557da85e1dbe23846a4bd466be0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "578d8f8487f33ded8faa3dd86d5a07cb5d84143a7d83f23ecb20fa9446b8e675"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end