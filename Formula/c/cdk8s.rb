require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.13.tgz"
  sha256 "bb347e60147db1aebf831b4f7bec61243bf312579de087a340ab6ddca350aadf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ec368ebb7a906d5b0585b394b1f7527f1e021ae17d3a02588e0dcbfbdbf50ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ec368ebb7a906d5b0585b394b1f7527f1e021ae17d3a02588e0dcbfbdbf50ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ec368ebb7a906d5b0585b394b1f7527f1e021ae17d3a02588e0dcbfbdbf50ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "9bfb6d00aa09a5367ef9c116ae2dcb10204dc7bac9202aa645d56de987767790"
    sha256 cellar: :any_skip_relocation, ventura:        "9bfb6d00aa09a5367ef9c116ae2dcb10204dc7bac9202aa645d56de987767790"
    sha256 cellar: :any_skip_relocation, monterey:       "9bfb6d00aa09a5367ef9c116ae2dcb10204dc7bac9202aa645d56de987767790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ec368ebb7a906d5b0585b394b1f7527f1e021ae17d3a02588e0dcbfbdbf50ed"
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