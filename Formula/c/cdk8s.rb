require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.178.0.tgz"
  sha256 "ef0a59d26351cf2fef190c04be0f8edf00373c34ccad311fef80247caafe4d1f"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7567e2c141d0a1a20f910acd4002ab8a191e6b22f220583972e830d886a3655a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7567e2c141d0a1a20f910acd4002ab8a191e6b22f220583972e830d886a3655a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7567e2c141d0a1a20f910acd4002ab8a191e6b22f220583972e830d886a3655a"
    sha256 cellar: :any_skip_relocation, sonoma:         "4dd9376cfbc7fd17856553881cf80aea1c731f5423c119f8cde429a8ecb485a1"
    sha256 cellar: :any_skip_relocation, ventura:        "4dd9376cfbc7fd17856553881cf80aea1c731f5423c119f8cde429a8ecb485a1"
    sha256 cellar: :any_skip_relocation, monterey:       "4dd9376cfbc7fd17856553881cf80aea1c731f5423c119f8cde429a8ecb485a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7567e2c141d0a1a20f910acd4002ab8a191e6b22f220583972e830d886a3655a"
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