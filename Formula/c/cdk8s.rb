require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.112.tgz"
  sha256 "bc6daddc40df0dd26627329f00aefbaa69aa1d199e5eaeb80d5849b179116018"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2c49dea797eaa95e6fdca9ecae37f750924c3dacc1927a0ef5768574ccd28d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2c49dea797eaa95e6fdca9ecae37f750924c3dacc1927a0ef5768574ccd28d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2c49dea797eaa95e6fdca9ecae37f750924c3dacc1927a0ef5768574ccd28d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a9eaa8e0c59efcf40fef744dfb99723d13d9d5cc4e207c84b3761b7e057f07f"
    sha256 cellar: :any_skip_relocation, ventura:        "2a9eaa8e0c59efcf40fef744dfb99723d13d9d5cc4e207c84b3761b7e057f07f"
    sha256 cellar: :any_skip_relocation, monterey:       "2a9eaa8e0c59efcf40fef744dfb99723d13d9d5cc4e207c84b3761b7e057f07f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2c49dea797eaa95e6fdca9ecae37f750924c3dacc1927a0ef5768574ccd28d7"
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