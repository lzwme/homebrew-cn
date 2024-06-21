require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.151.tgz"
  sha256 "bc3d2a7f0f2fde237eb35689dd691e48da812a449a15ac674f9198e7a6f66caf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7586d59b4e28420e5ee63e12babf9d27401c59d2727ac78c6a10dbaa93a498f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7586d59b4e28420e5ee63e12babf9d27401c59d2727ac78c6a10dbaa93a498f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7586d59b4e28420e5ee63e12babf9d27401c59d2727ac78c6a10dbaa93a498f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d58350ca4c7c22ec61c6cb1b4e7fc19e1e4a0180665ae4f660c4817b7ef9c73"
    sha256 cellar: :any_skip_relocation, ventura:        "2d58350ca4c7c22ec61c6cb1b4e7fc19e1e4a0180665ae4f660c4817b7ef9c73"
    sha256 cellar: :any_skip_relocation, monterey:       "2d58350ca4c7c22ec61c6cb1b4e7fc19e1e4a0180665ae4f660c4817b7ef9c73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86ed50a599b1e7bd5a703d5eb14e9594f020a9b9d275b4557c4b2d439305b208"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end