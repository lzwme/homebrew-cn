require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.18.tgz"
  sha256 "3e44572eefd10f73fd7d44e51364646c32de9456f39dad2fa75a5a693619d759"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68e274f9fd8e454ffdb3e02d5996a1c7edb74e0a6a88fd943771d37385fac24a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68e274f9fd8e454ffdb3e02d5996a1c7edb74e0a6a88fd943771d37385fac24a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68e274f9fd8e454ffdb3e02d5996a1c7edb74e0a6a88fd943771d37385fac24a"
    sha256 cellar: :any_skip_relocation, sonoma:         "cbfa6da9eb7b1496ebda12156d8a5f7427f4ff712dd3186a7640d5570c221cd6"
    sha256 cellar: :any_skip_relocation, ventura:        "cbfa6da9eb7b1496ebda12156d8a5f7427f4ff712dd3186a7640d5570c221cd6"
    sha256 cellar: :any_skip_relocation, monterey:       "cbfa6da9eb7b1496ebda12156d8a5f7427f4ff712dd3186a7640d5570c221cd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68e274f9fd8e454ffdb3e02d5996a1c7edb74e0a6a88fd943771d37385fac24a"
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