require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.54.tgz"
  sha256 "9bc8da8910ec3e2e85fa393f4c15ff326df50d1e79ad8b1f732c53258fa38efc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35d0217eaaf48424b441e8fa6a3709f262a58b7d1c256050c3fa39ce675e5b4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35d0217eaaf48424b441e8fa6a3709f262a58b7d1c256050c3fa39ce675e5b4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35d0217eaaf48424b441e8fa6a3709f262a58b7d1c256050c3fa39ce675e5b4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "344c1698c82400f93a0d8b7500a92cb5757b983508b590b03b9cf21c8bfe7ba0"
    sha256 cellar: :any_skip_relocation, ventura:        "344c1698c82400f93a0d8b7500a92cb5757b983508b590b03b9cf21c8bfe7ba0"
    sha256 cellar: :any_skip_relocation, monterey:       "344c1698c82400f93a0d8b7500a92cb5757b983508b590b03b9cf21c8bfe7ba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35d0217eaaf48424b441e8fa6a3709f262a58b7d1c256050c3fa39ce675e5b4f"
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