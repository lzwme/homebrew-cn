require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.11.tgz"
  sha256 "07a66785dedfb74cb0d6b6488772a1499b9549328e39ea5ff44acd8f4160bb8d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2c056d9b36e1c72a92baa70fa0184f4d20064dc0357b195c1a158e3b69e969d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2c056d9b36e1c72a92baa70fa0184f4d20064dc0357b195c1a158e3b69e969d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2c056d9b36e1c72a92baa70fa0184f4d20064dc0357b195c1a158e3b69e969d"
    sha256 cellar: :any_skip_relocation, sonoma:         "0508fc4f19b5116bc559eaebd1bcf735dd73f4948e455739c4be257b91b286c2"
    sha256 cellar: :any_skip_relocation, ventura:        "0508fc4f19b5116bc559eaebd1bcf735dd73f4948e455739c4be257b91b286c2"
    sha256 cellar: :any_skip_relocation, monterey:       "0508fc4f19b5116bc559eaebd1bcf735dd73f4948e455739c4be257b91b286c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2c056d9b36e1c72a92baa70fa0184f4d20064dc0357b195c1a158e3b69e969d"
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