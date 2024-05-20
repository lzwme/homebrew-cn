require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.122.tgz"
  sha256 "94f14c4c8a04cd22843cd4bbcc2703797a6044641644539d995958fbb26ab890"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "293ebcf9a8b16f8521441e8c16d83bbdbad7b9f1ccc44d2d9e2578969000527c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "887b4f9dda5cfdf07f7e4f204207a11692591182b38020f8ceafdadbe44e41d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5624645e5d48c7dc22822c9d88e1662617db0a1c046f68b457dd52b43f33e11"
    sha256 cellar: :any_skip_relocation, sonoma:         "1cf6d80bd83db70b93c88cbccef25ea3c2ec10ecb128a073e1d31746cddd7716"
    sha256 cellar: :any_skip_relocation, ventura:        "08033c14e03a79b37c25dd5a640ac0640dd3b47b71a760ecaf80fff524979dc5"
    sha256 cellar: :any_skip_relocation, monterey:       "736aa03b0cb085ab34b61c08e299057f5582711b97b060c71a33686823077889"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8a6f8d9fb1e81517b9b61a5d23cb2c4ce7660aef31901e2ac20bae8749cc7df"
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