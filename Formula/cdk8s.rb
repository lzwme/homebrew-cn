require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.54.tgz"
  sha256 "eaf64bcb2de2dd8b5e04e18e36bb8c027159b792b7eb2ff29a70f0ec9c9bc6f9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa55f276fe40a5d1459ef81348ae6ec7fc2c3f450c6767b7424c4a82b1bca2c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa55f276fe40a5d1459ef81348ae6ec7fc2c3f450c6767b7424c4a82b1bca2c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa55f276fe40a5d1459ef81348ae6ec7fc2c3f450c6767b7424c4a82b1bca2c9"
    sha256 cellar: :any_skip_relocation, ventura:        "47c8b8750d53d3e5ac5c702d9c1ffa061889ce6dccee013dcbee190c23565b09"
    sha256 cellar: :any_skip_relocation, monterey:       "47c8b8750d53d3e5ac5c702d9c1ffa061889ce6dccee013dcbee190c23565b09"
    sha256 cellar: :any_skip_relocation, big_sur:        "47c8b8750d53d3e5ac5c702d9c1ffa061889ce6dccee013dcbee190c23565b09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa55f276fe40a5d1459ef81348ae6ec7fc2c3f450c6767b7424c4a82b1bca2c9"
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