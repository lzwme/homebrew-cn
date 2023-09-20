require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.94.0.tgz"
  sha256 "9076505f26967bcb380cc1bbc37d468493787a0d9b2f107e77bbf75b4d5f6099"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5d4043c390369096b337021592e88f0ca4a01737a911c9b9ce97f7cfe7028fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5d4043c390369096b337021592e88f0ca4a01737a911c9b9ce97f7cfe7028fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5d4043c390369096b337021592e88f0ca4a01737a911c9b9ce97f7cfe7028fb"
    sha256 cellar: :any_skip_relocation, ventura:        "c1655329e44ccaf278cc447e876e62c2c623e9ce628b5e63f12e7afa28c61af2"
    sha256 cellar: :any_skip_relocation, monterey:       "bb9484a3dfebf7045a0d9962d1e4c83fc1d710a13fcf9f49eee4d738c5a75533"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb9484a3dfebf7045a0d9962d1e4c83fc1d710a13fcf9f49eee4d738c5a75533"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5d4043c390369096b337021592e88f0ca4a01737a911c9b9ce97f7cfe7028fb"
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