require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.83.tgz"
  sha256 "d938330b639bd27fa84c7bd5807d4e68740a3cc313c92c488546cb844c3561fe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d42ec4af2bdd52552f4ce7382c56e85b69d98aab3985fb6a32b6150f10e30ab6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d42ec4af2bdd52552f4ce7382c56e85b69d98aab3985fb6a32b6150f10e30ab6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d42ec4af2bdd52552f4ce7382c56e85b69d98aab3985fb6a32b6150f10e30ab6"
    sha256 cellar: :any_skip_relocation, ventura:        "e73a6e294aee3daa64c5a2a3f85bfcf1e32b6c8600d234c0dd8eeec38c470715"
    sha256 cellar: :any_skip_relocation, monterey:       "e73a6e294aee3daa64c5a2a3f85bfcf1e32b6c8600d234c0dd8eeec38c470715"
    sha256 cellar: :any_skip_relocation, big_sur:        "e73a6e294aee3daa64c5a2a3f85bfcf1e32b6c8600d234c0dd8eeec38c470715"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d42ec4af2bdd52552f4ce7382c56e85b69d98aab3985fb6a32b6150f10e30ab6"
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