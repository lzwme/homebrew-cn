require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.82.0.tgz"
  sha256 "0a4bbe3df69db908f8b258c355e1c5d0e5c41dea3e276c7ea7cd16541e8911a8"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92b33f3620dbe68131ddb708dc1d0e92bdaf8e2c499c8ba7604e379a52f4a73f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92b33f3620dbe68131ddb708dc1d0e92bdaf8e2c499c8ba7604e379a52f4a73f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92b33f3620dbe68131ddb708dc1d0e92bdaf8e2c499c8ba7604e379a52f4a73f"
    sha256 cellar: :any_skip_relocation, ventura:        "27f3b5f867e55d6d2fca4fa873aa05f75bb63d61ed2dcd67db6931d78fe9bc09"
    sha256 cellar: :any_skip_relocation, monterey:       "27f3b5f867e55d6d2fca4fa873aa05f75bb63d61ed2dcd67db6931d78fe9bc09"
    sha256 cellar: :any_skip_relocation, big_sur:        "27f3b5f867e55d6d2fca4fa873aa05f75bb63d61ed2dcd67db6931d78fe9bc09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92b33f3620dbe68131ddb708dc1d0e92bdaf8e2c499c8ba7604e379a52f4a73f"
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