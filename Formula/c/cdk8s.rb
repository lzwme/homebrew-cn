require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.63.tgz"
  sha256 "ce2c415ae100bf14531f1667a65b98be8c1589359e018748357486dbb12fa284"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29542679e7e60d461a941e1121e4e39a459665498b46ec2c399df80de8791840"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29542679e7e60d461a941e1121e4e39a459665498b46ec2c399df80de8791840"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29542679e7e60d461a941e1121e4e39a459665498b46ec2c399df80de8791840"
    sha256 cellar: :any_skip_relocation, sonoma:         "558dbd0fb2c1625a263bcdf01820789f7c0f89943fa9dd9028a0e96007d9b0e3"
    sha256 cellar: :any_skip_relocation, ventura:        "558dbd0fb2c1625a263bcdf01820789f7c0f89943fa9dd9028a0e96007d9b0e3"
    sha256 cellar: :any_skip_relocation, monterey:       "558dbd0fb2c1625a263bcdf01820789f7c0f89943fa9dd9028a0e96007d9b0e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29542679e7e60d461a941e1121e4e39a459665498b46ec2c399df80de8791840"
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