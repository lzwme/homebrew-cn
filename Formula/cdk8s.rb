require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.14.0.tgz"
  sha256 "fc0dc013f89d799418a914d15537462ad81e4f082fad19a5943361e38ba4595a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcda38bf7691c63bbedaad80a9316a2167da7484fbdaa263a0c78d9b38e22e2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcda38bf7691c63bbedaad80a9316a2167da7484fbdaa263a0c78d9b38e22e2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dcda38bf7691c63bbedaad80a9316a2167da7484fbdaa263a0c78d9b38e22e2c"
    sha256 cellar: :any_skip_relocation, ventura:        "7265e359e513d5110ac2c821cc717ab02f7b11cbbd47a4fd6abb15cbff959d39"
    sha256 cellar: :any_skip_relocation, monterey:       "7265e359e513d5110ac2c821cc717ab02f7b11cbbd47a4fd6abb15cbff959d39"
    sha256 cellar: :any_skip_relocation, big_sur:        "7265e359e513d5110ac2c821cc717ab02f7b11cbbd47a4fd6abb15cbff959d39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4338f51286339865ff497ff2c416763794bda4440f586e29019c884589d19c2"
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