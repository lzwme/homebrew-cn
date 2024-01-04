require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.25.tgz"
  sha256 "7b8bd7720166e9ef8d6aba1f28be3ab2ceac42b735d54170c07f3a4f14b4efdd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ead4e7f5b244542b5439f47866880ee498e2755acfab4531d99773404531508"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ead4e7f5b244542b5439f47866880ee498e2755acfab4531d99773404531508"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ead4e7f5b244542b5439f47866880ee498e2755acfab4531d99773404531508"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a01d47f55228298aff04da8df7b92db5b9bb9d1579236174c877e3fbf55256b"
    sha256 cellar: :any_skip_relocation, ventura:        "7a01d47f55228298aff04da8df7b92db5b9bb9d1579236174c877e3fbf55256b"
    sha256 cellar: :any_skip_relocation, monterey:       "7a01d47f55228298aff04da8df7b92db5b9bb9d1579236174c877e3fbf55256b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ead4e7f5b244542b5439f47866880ee498e2755acfab4531d99773404531508"
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