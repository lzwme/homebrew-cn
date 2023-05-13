require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.32.tgz"
  sha256 "22a29e9fd3d87a9a18bb9dc8d43d0bbdb62f33366bf7d79a3f13cddf21b1f8cd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a02b82699c325c9ad4afa1abcd40db3530f6114b3ed1f5b2e04f67c45ccc7a3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a02b82699c325c9ad4afa1abcd40db3530f6114b3ed1f5b2e04f67c45ccc7a3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a02b82699c325c9ad4afa1abcd40db3530f6114b3ed1f5b2e04f67c45ccc7a3e"
    sha256 cellar: :any_skip_relocation, ventura:        "e5ae0f5cddcbd970821f96962676281e9d65512e9c2b0cd2cebdf2d218252f7e"
    sha256 cellar: :any_skip_relocation, monterey:       "e5ae0f5cddcbd970821f96962676281e9d65512e9c2b0cd2cebdf2d218252f7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5ae0f5cddcbd970821f96962676281e9d65512e9c2b0cd2cebdf2d218252f7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a02b82699c325c9ad4afa1abcd40db3530f6114b3ed1f5b2e04f67c45ccc7a3e"
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