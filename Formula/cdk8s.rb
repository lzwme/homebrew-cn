require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.18.tgz"
  sha256 "25be790e4efe8ad4194adf09bab118665a3b693e3d9f2b7a1664ae430a3ade20"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b891b6528a69fc68a616bbb940515be0c4c6e97249a384e6c0801a929815dcd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b891b6528a69fc68a616bbb940515be0c4c6e97249a384e6c0801a929815dcd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b891b6528a69fc68a616bbb940515be0c4c6e97249a384e6c0801a929815dcd"
    sha256 cellar: :any_skip_relocation, ventura:        "e030cbd0a46566b20bb54820f39465a1598c5e4ed5334a63f89fcb1f6bc6b064"
    sha256 cellar: :any_skip_relocation, monterey:       "e030cbd0a46566b20bb54820f39465a1598c5e4ed5334a63f89fcb1f6bc6b064"
    sha256 cellar: :any_skip_relocation, big_sur:        "e030cbd0a46566b20bb54820f39465a1598c5e4ed5334a63f89fcb1f6bc6b064"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b891b6528a69fc68a616bbb940515be0c4c6e97249a384e6c0801a929815dcd"
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