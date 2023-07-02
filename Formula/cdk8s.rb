require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.84.tgz"
  sha256 "c39ed41e33afb9c29dc2e1681d62ea1ea7be766ec0f6b2740176b7b38e7497b3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df3c5a6c4f2dd8f3d1b5c7b33b6b4aa9e5ebacd056ef071def8a47aaf76828b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df3c5a6c4f2dd8f3d1b5c7b33b6b4aa9e5ebacd056ef071def8a47aaf76828b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba73633a95a18ece53befb2540d47400b4d451f0ae95af2af03388a98e894835"
    sha256 cellar: :any_skip_relocation, ventura:        "27d106b58639da5fd3f4481819c83e398a9bf09267933216d1496ad255460221"
    sha256 cellar: :any_skip_relocation, monterey:       "27d106b58639da5fd3f4481819c83e398a9bf09267933216d1496ad255460221"
    sha256 cellar: :any_skip_relocation, big_sur:        "27d106b58639da5fd3f4481819c83e398a9bf09267933216d1496ad255460221"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba73633a95a18ece53befb2540d47400b4d451f0ae95af2af03388a98e894835"
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