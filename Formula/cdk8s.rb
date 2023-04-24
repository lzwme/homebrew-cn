require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.17.tgz"
  sha256 "509e877820eb91dc8f63185e84c4ecb0889499b918aa32595898195024405767"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbc764270afba22e94a3e8ae5718200c35b4d4cff42cf2f6e03429d278be7d29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbc764270afba22e94a3e8ae5718200c35b4d4cff42cf2f6e03429d278be7d29"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bbc764270afba22e94a3e8ae5718200c35b4d4cff42cf2f6e03429d278be7d29"
    sha256 cellar: :any_skip_relocation, ventura:        "4b4bc7bb598cf44f5e2f4c36816b944e5a32889289953b921ca3aa40499a5344"
    sha256 cellar: :any_skip_relocation, monterey:       "4b4bc7bb598cf44f5e2f4c36816b944e5a32889289953b921ca3aa40499a5344"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b4bc7bb598cf44f5e2f4c36816b944e5a32889289953b921ca3aa40499a5344"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbc764270afba22e94a3e8ae5718200c35b4d4cff42cf2f6e03429d278be7d29"
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