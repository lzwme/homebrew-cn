require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.20.tgz"
  sha256 "ae3c446b216f52be4349c38d4c986069988912c527bc6f38bb2e43b12ae48436"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1fc3d3e506f9a907de6ed9ceae262d581d3bed6cb4732ffa5627312ed9910b21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1fc3d3e506f9a907de6ed9ceae262d581d3bed6cb4732ffa5627312ed9910b21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fc3d3e506f9a907de6ed9ceae262d581d3bed6cb4732ffa5627312ed9910b21"
    sha256 cellar: :any_skip_relocation, sonoma:         "d85631d57ed501ce6c12a3e032dbbdb3ae86a1e28cd6e1fa7db7e0a79c5168a2"
    sha256 cellar: :any_skip_relocation, ventura:        "d85631d57ed501ce6c12a3e032dbbdb3ae86a1e28cd6e1fa7db7e0a79c5168a2"
    sha256 cellar: :any_skip_relocation, monterey:       "d85631d57ed501ce6c12a3e032dbbdb3ae86a1e28cd6e1fa7db7e0a79c5168a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fc3d3e506f9a907de6ed9ceae262d581d3bed6cb4732ffa5627312ed9910b21"
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