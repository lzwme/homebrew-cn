require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.26.tgz"
  sha256 "d97738d58f2bd5159e697d8ff5259c8fee78557016cce5025a484c0036c98d98"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7265fce81a6a7c30ce03d77940c77837c8b2816d2c9c3a626b71b11dfff167ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7265fce81a6a7c30ce03d77940c77837c8b2816d2c9c3a626b71b11dfff167ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "044fbbcf2ec28cfdb9331404b9311dc697f17cd7b39d37c073bb376c9ad8d068"
    sha256 cellar: :any_skip_relocation, ventura:        "6c4f691c689c30cb52d81c5bf349b6e00e30dc82523ba2b2e532a20543706dce"
    sha256 cellar: :any_skip_relocation, monterey:       "6a2bd0f1b90ed1994ee82531dc21bd92612537b846dac0c42092a69f58d06133"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a2bd0f1b90ed1994ee82531dc21bd92612537b846dac0c42092a69f58d06133"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "044fbbcf2ec28cfdb9331404b9311dc697f17cd7b39d37c073bb376c9ad8d068"
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