require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.52.tgz"
  sha256 "35351271b688dc7543900201ef2e51ebbeb9a9a0ad94d49067ef79b33374a8e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd8fb18c4fb36e10241fc43e754e25340f39e9549fc4bfeb7b7257828e39c472"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd8fb18c4fb36e10241fc43e754e25340f39e9549fc4bfeb7b7257828e39c472"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd8fb18c4fb36e10241fc43e754e25340f39e9549fc4bfeb7b7257828e39c472"
    sha256 cellar: :any_skip_relocation, ventura:        "df650e3334952c9fdba04be7fd15c74a410ba2a2957a28ead8bf2b6dde0155f1"
    sha256 cellar: :any_skip_relocation, monterey:       "df650e3334952c9fdba04be7fd15c74a410ba2a2957a28ead8bf2b6dde0155f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "df650e3334952c9fdba04be7fd15c74a410ba2a2957a28ead8bf2b6dde0155f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd8fb18c4fb36e10241fc43e754e25340f39e9549fc4bfeb7b7257828e39c472"
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