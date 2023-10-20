require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.148.0.tgz"
  sha256 "ce47c21d5ce5700ad83081ca6a09cb589bdb91096d14a7dc728aa773b76f003a"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8e6988b05cc8e6e55fa14acfb9d08b7fa87446d20297ef41cc1f083c1118403"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8e6988b05cc8e6e55fa14acfb9d08b7fa87446d20297ef41cc1f083c1118403"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8e6988b05cc8e6e55fa14acfb9d08b7fa87446d20297ef41cc1f083c1118403"
    sha256 cellar: :any_skip_relocation, sonoma:         "3bcf0b2407b822c8d8f99384d26b9b94662d71e338da28aec3494296d3e48266"
    sha256 cellar: :any_skip_relocation, ventura:        "3bcf0b2407b822c8d8f99384d26b9b94662d71e338da28aec3494296d3e48266"
    sha256 cellar: :any_skip_relocation, monterey:       "3bcf0b2407b822c8d8f99384d26b9b94662d71e338da28aec3494296d3e48266"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8e6988b05cc8e6e55fa14acfb9d08b7fa87446d20297ef41cc1f083c1118403"
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