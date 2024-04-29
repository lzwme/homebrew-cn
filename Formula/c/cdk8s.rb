require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.107.tgz"
  sha256 "dde5dabf76e80bffe059f92d1462663ff9e586b807da338a2ef9f2ad4776fb5a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "77a6428ebd156cd61bf1b72d1c7a0cabba85d470d708dc125de1713609a078f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77a6428ebd156cd61bf1b72d1c7a0cabba85d470d708dc125de1713609a078f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77a6428ebd156cd61bf1b72d1c7a0cabba85d470d708dc125de1713609a078f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "631e01d0817d65bea50679be605773416fc54ca7ac015f0e488c031731ea8e17"
    sha256 cellar: :any_skip_relocation, ventura:        "631e01d0817d65bea50679be605773416fc54ca7ac015f0e488c031731ea8e17"
    sha256 cellar: :any_skip_relocation, monterey:       "631e01d0817d65bea50679be605773416fc54ca7ac015f0e488c031731ea8e17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77a6428ebd156cd61bf1b72d1c7a0cabba85d470d708dc125de1713609a078f4"
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