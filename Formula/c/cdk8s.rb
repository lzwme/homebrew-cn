require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.47.tgz"
  sha256 "d7589a1cae9b2cb8fa2231dee64022560d9695075917d5abeeea5c1dd95f7a26"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eff69e5389584f8860d128a509143ba1fd00f4768e946c8d268b6b1ac89b225e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eff69e5389584f8860d128a509143ba1fd00f4768e946c8d268b6b1ac89b225e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eff69e5389584f8860d128a509143ba1fd00f4768e946c8d268b6b1ac89b225e"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e564d9dd7c007404fd29161dbf7dd9115c71f59b778ccff43f710c91fe25c14"
    sha256 cellar: :any_skip_relocation, ventura:        "9e564d9dd7c007404fd29161dbf7dd9115c71f59b778ccff43f710c91fe25c14"
    sha256 cellar: :any_skip_relocation, monterey:       "9e564d9dd7c007404fd29161dbf7dd9115c71f59b778ccff43f710c91fe25c14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eff69e5389584f8860d128a509143ba1fd00f4768e946c8d268b6b1ac89b225e"
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