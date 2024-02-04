require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.38.tgz"
  sha256 "8fbe7cb75a031a39b3e1b661f1bc825cf0d6bb593da92b690e2c98d017b0bdf9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73524144788afb14cb3b8dab4087e44bfc797989125e0abc5d8a82468355e2e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73524144788afb14cb3b8dab4087e44bfc797989125e0abc5d8a82468355e2e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73524144788afb14cb3b8dab4087e44bfc797989125e0abc5d8a82468355e2e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d4b5aa987800bcd16c59e4aba32a3d9e1850ddac0d278a62df1a8d9c13bc6d9"
    sha256 cellar: :any_skip_relocation, ventura:        "4d4b5aa987800bcd16c59e4aba32a3d9e1850ddac0d278a62df1a8d9c13bc6d9"
    sha256 cellar: :any_skip_relocation, monterey:       "4d4b5aa987800bcd16c59e4aba32a3d9e1850ddac0d278a62df1a8d9c13bc6d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73524144788afb14cb3b8dab4087e44bfc797989125e0abc5d8a82468355e2e9"
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