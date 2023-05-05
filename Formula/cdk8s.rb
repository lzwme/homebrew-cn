require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.27.tgz"
  sha256 "348c482a17187827a86e96a0251b233709ea6f7076c9a9c24c01a011f13a48ce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e68a5d4995be088acab711d85cd22a254ede44d8f289e1f1b56f5c3353cbfa7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e68a5d4995be088acab711d85cd22a254ede44d8f289e1f1b56f5c3353cbfa7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e82d0fbf9bf1d3f06c8ab17c45d31285a4f2feae230342fc07e65de89cc8c98b"
    sha256 cellar: :any_skip_relocation, ventura:        "ac71779a88ca1a0dcd0957bc3fc067cbb9951623f77e8cc8c2df13865f382631"
    sha256 cellar: :any_skip_relocation, monterey:       "ac71779a88ca1a0dcd0957bc3fc067cbb9951623f77e8cc8c2df13865f382631"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac71779a88ca1a0dcd0957bc3fc067cbb9951623f77e8cc8c2df13865f382631"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e68a5d4995be088acab711d85cd22a254ede44d8f289e1f1b56f5c3353cbfa7"
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