require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.167.tgz"
  sha256 "06c1bf599783ba3d36bd75597b4bcaf2f440bd60bd4379563446167a0765ec97"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4b9295927b5c1b9f20c41d922657fad464524b2577cd7ec46f3b107db197c47"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4b9295927b5c1b9f20c41d922657fad464524b2577cd7ec46f3b107db197c47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4b9295927b5c1b9f20c41d922657fad464524b2577cd7ec46f3b107db197c47"
    sha256 cellar: :any_skip_relocation, sonoma:         "0304e17c24473f12275463bf2c6438e68723291daae228c284737552bb4dbc97"
    sha256 cellar: :any_skip_relocation, ventura:        "0304e17c24473f12275463bf2c6438e68723291daae228c284737552bb4dbc97"
    sha256 cellar: :any_skip_relocation, monterey:       "0304e17c24473f12275463bf2c6438e68723291daae228c284737552bb4dbc97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64eb43829b6aa97ae6842362da67eede936cfe3fbbf161a08a2b7418951afccc"
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