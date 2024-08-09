class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.183.tgz"
  sha256 "6206f9bbf18f77a31595efaf81ac248d4b599d0f9021dd08ca136de03488d072"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6d91003ce80786f5eff77af64a3d29056331d37dae81d472cde390db92b095b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6d91003ce80786f5eff77af64a3d29056331d37dae81d472cde390db92b095b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6d91003ce80786f5eff77af64a3d29056331d37dae81d472cde390db92b095b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a06b186585ae86069cdb9be8529165fe3fa04cee92e05925d4f88fc8ec2106d6"
    sha256 cellar: :any_skip_relocation, ventura:        "a06b186585ae86069cdb9be8529165fe3fa04cee92e05925d4f88fc8ec2106d6"
    sha256 cellar: :any_skip_relocation, monterey:       "a06b186585ae86069cdb9be8529165fe3fa04cee92e05925d4f88fc8ec2106d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bfb1ccf33795e24eb0a844a3b367de5ecb9a44264c6c62fdbe9b36c9c0fe92a"
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