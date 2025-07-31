class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.145.tgz"
  sha256 "aed85a5fb5d4494c0229d86442c0150f43b1db873b6ca18cd4bdd1f555ab7073"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc7ecb8ffd898f3544eb45a333851a6f9680dd2796fc18df763d24183bce0195"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc7ecb8ffd898f3544eb45a333851a6f9680dd2796fc18df763d24183bce0195"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc7ecb8ffd898f3544eb45a333851a6f9680dd2796fc18df763d24183bce0195"
    sha256 cellar: :any_skip_relocation, sonoma:        "22e0e6ed6fa7fb2ecb98ef05af6df26c9e1dc6c682e8a71902d7d26d89567e86"
    sha256 cellar: :any_skip_relocation, ventura:       "22e0e6ed6fa7fb2ecb98ef05af6df26c9e1dc6c682e8a71902d7d26d89567e86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc7ecb8ffd898f3544eb45a333851a6f9680dd2796fc18df763d24183bce0195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc7ecb8ffd898f3544eb45a333851a6f9680dd2796fc18df763d24183bce0195"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end