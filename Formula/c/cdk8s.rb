require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.14.tgz"
  sha256 "020a3a8bed52a9d0480d809b2d15811926df246f9a6e7e8a55e3a9cd82ae5873"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3da345cb8a98454b8602ca91a0851d8f84738a28c70e8437d2b29f2cf136cfa4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3da345cb8a98454b8602ca91a0851d8f84738a28c70e8437d2b29f2cf136cfa4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3da345cb8a98454b8602ca91a0851d8f84738a28c70e8437d2b29f2cf136cfa4"
    sha256 cellar: :any_skip_relocation, sonoma:         "958eeff42539757f71e0093013653b6db2e00936f43ce64644508bfb857da3df"
    sha256 cellar: :any_skip_relocation, ventura:        "958eeff42539757f71e0093013653b6db2e00936f43ce64644508bfb857da3df"
    sha256 cellar: :any_skip_relocation, monterey:       "958eeff42539757f71e0093013653b6db2e00936f43ce64644508bfb857da3df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3da345cb8a98454b8602ca91a0851d8f84738a28c70e8437d2b29f2cf136cfa4"
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