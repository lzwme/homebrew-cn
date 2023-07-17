require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.112.tgz"
  sha256 "68f298c62cbf5ad6cfe709e607dffb083d575c0868bf2beff447c6d7129edf37"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02f48a415ea953a4327811562ff7107fc5135fc90b49e2b2d6157674c737749f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02f48a415ea953a4327811562ff7107fc5135fc90b49e2b2d6157674c737749f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02f48a415ea953a4327811562ff7107fc5135fc90b49e2b2d6157674c737749f"
    sha256 cellar: :any_skip_relocation, ventura:        "a9de0ae962df7c9b35d51cf7bea4499f042070a0424b16d55d2017d95fd2bf99"
    sha256 cellar: :any_skip_relocation, monterey:       "a9de0ae962df7c9b35d51cf7bea4499f042070a0424b16d55d2017d95fd2bf99"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9de0ae962df7c9b35d51cf7bea4499f042070a0424b16d55d2017d95fd2bf99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02f48a415ea953a4327811562ff7107fc5135fc90b49e2b2d6157674c737749f"
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