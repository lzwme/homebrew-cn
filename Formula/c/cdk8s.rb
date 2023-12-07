require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.2.tgz"
  sha256 "af9e1ab30acca74204d402f3044e5ec83d776013996db6709ce7b6917b59612b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be3ffd231cf275665b8bf4b31a387c7519740796ef0b47b18ff2c1c62e479e93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be3ffd231cf275665b8bf4b31a387c7519740796ef0b47b18ff2c1c62e479e93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be3ffd231cf275665b8bf4b31a387c7519740796ef0b47b18ff2c1c62e479e93"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f07b6017bb862cfaf5769b86c36432e15d32b670a9cf8904629530029beb5c7"
    sha256 cellar: :any_skip_relocation, ventura:        "7f07b6017bb862cfaf5769b86c36432e15d32b670a9cf8904629530029beb5c7"
    sha256 cellar: :any_skip_relocation, monterey:       "7f07b6017bb862cfaf5769b86c36432e15d32b670a9cf8904629530029beb5c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be3ffd231cf275665b8bf4b31a387c7519740796ef0b47b18ff2c1c62e479e93"
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