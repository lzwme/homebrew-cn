require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.46.tgz"
  sha256 "7760f58889bbf2d9956e51936a7b61f8fe476cf3275bb20d0469be7f3d17f262"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2fd60ef1b2eade37d761c95d171b91b0f6c7d3942ba273413c4c2046ddf917fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fd60ef1b2eade37d761c95d171b91b0f6c7d3942ba273413c4c2046ddf917fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fd60ef1b2eade37d761c95d171b91b0f6c7d3942ba273413c4c2046ddf917fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "54a405bccd55fb03e0f68c81517fcc333250c24a6731b2a9aeb3d4a335cf67ec"
    sha256 cellar: :any_skip_relocation, ventura:        "54a405bccd55fb03e0f68c81517fcc333250c24a6731b2a9aeb3d4a335cf67ec"
    sha256 cellar: :any_skip_relocation, monterey:       "54a405bccd55fb03e0f68c81517fcc333250c24a6731b2a9aeb3d4a335cf67ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fd60ef1b2eade37d761c95d171b91b0f6c7d3942ba273413c4c2046ddf917fb"
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