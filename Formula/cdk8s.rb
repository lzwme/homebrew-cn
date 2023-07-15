require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.109.tgz"
  sha256 "7a5538d2d4d0e17b2adf64a872d0a10a52f3b56801c2eaf52bfe371acd39af15"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be31dacd2c8bd7a34dae15a237fa9eb8ebecf2777d8b0e4cf44c6705190dbacb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be31dacd2c8bd7a34dae15a237fa9eb8ebecf2777d8b0e4cf44c6705190dbacb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be31dacd2c8bd7a34dae15a237fa9eb8ebecf2777d8b0e4cf44c6705190dbacb"
    sha256 cellar: :any_skip_relocation, ventura:        "49eab77e8278711af6fb5c849b747bfd5def0ce92f22f9bd3511885aeb93a611"
    sha256 cellar: :any_skip_relocation, monterey:       "49eab77e8278711af6fb5c849b747bfd5def0ce92f22f9bd3511885aeb93a611"
    sha256 cellar: :any_skip_relocation, big_sur:        "49eab77e8278711af6fb5c849b747bfd5def0ce92f22f9bd3511885aeb93a611"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be31dacd2c8bd7a34dae15a237fa9eb8ebecf2777d8b0e4cf44c6705190dbacb"
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