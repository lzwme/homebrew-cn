require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.53.tgz"
  sha256 "9a8f63a016425713c2190963c5a909ce53600d7f73e698cc89662810d965b6f0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5dafaece811d727b0080a18316dfae32f758c62dbc690da232d50407951ec8e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5dafaece811d727b0080a18316dfae32f758c62dbc690da232d50407951ec8e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5dafaece811d727b0080a18316dfae32f758c62dbc690da232d50407951ec8e9"
    sha256 cellar: :any_skip_relocation, ventura:        "62ef9bd3887fe44be5048ffc3f46f4f9def84efb3b9aaaf451b5cb515e13351d"
    sha256 cellar: :any_skip_relocation, monterey:       "62ef9bd3887fe44be5048ffc3f46f4f9def84efb3b9aaaf451b5cb515e13351d"
    sha256 cellar: :any_skip_relocation, big_sur:        "62ef9bd3887fe44be5048ffc3f46f4f9def84efb3b9aaaf451b5cb515e13351d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dafaece811d727b0080a18316dfae32f758c62dbc690da232d50407951ec8e9"
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