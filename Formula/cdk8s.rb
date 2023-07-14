require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.107.tgz"
  sha256 "4296d426d324ea19058dd034a7087188c81e44aba9d2e9ff546b022b2dab4afe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85e477050a5d2bd58bad04f0796a0b1f60494655b8065611a55449a643ff517c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85e477050a5d2bd58bad04f0796a0b1f60494655b8065611a55449a643ff517c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85e477050a5d2bd58bad04f0796a0b1f60494655b8065611a55449a643ff517c"
    sha256 cellar: :any_skip_relocation, ventura:        "f050f8908f164fa7d67f9fb12b741529cab0d85f892e111afc6942f9a012e589"
    sha256 cellar: :any_skip_relocation, monterey:       "f050f8908f164fa7d67f9fb12b741529cab0d85f892e111afc6942f9a012e589"
    sha256 cellar: :any_skip_relocation, big_sur:        "f050f8908f164fa7d67f9fb12b741529cab0d85f892e111afc6942f9a012e589"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85e477050a5d2bd58bad04f0796a0b1f60494655b8065611a55449a643ff517c"
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