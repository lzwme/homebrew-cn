require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.104.tgz"
  sha256 "f24740b832ee47ff6fd0722429daeb5a60cd4b85926568ef3e1785fe347eeadd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8056c3fe7e995cd0b334f5bd96b1914fff058ea542c208d462132560bfed3cb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8056c3fe7e995cd0b334f5bd96b1914fff058ea542c208d462132560bfed3cb9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8056c3fe7e995cd0b334f5bd96b1914fff058ea542c208d462132560bfed3cb9"
    sha256 cellar: :any_skip_relocation, sonoma:         "1868eb3fbd5f1be631f36fef850242887ea2188c77ad3a8421e2db1274023de0"
    sha256 cellar: :any_skip_relocation, ventura:        "1868eb3fbd5f1be631f36fef850242887ea2188c77ad3a8421e2db1274023de0"
    sha256 cellar: :any_skip_relocation, monterey:       "1868eb3fbd5f1be631f36fef850242887ea2188c77ad3a8421e2db1274023de0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8056c3fe7e995cd0b334f5bd96b1914fff058ea542c208d462132560bfed3cb9"
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