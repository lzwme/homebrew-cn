require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.23.tgz"
  sha256 "733cf1fd83b524517d5ad7ccdf977d542848760fb7e32c93641768fb1e58f45d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f266c6cc2694b12967424a549749762098a31a2247351106cf54ef0baf71d82"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f266c6cc2694b12967424a549749762098a31a2247351106cf54ef0baf71d82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f266c6cc2694b12967424a549749762098a31a2247351106cf54ef0baf71d82"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1d5d714ae46854a5a55ce30708deb110aad00df9a1a93bab0648b2fbdb6fbc4"
    sha256 cellar: :any_skip_relocation, ventura:        "a1d5d714ae46854a5a55ce30708deb110aad00df9a1a93bab0648b2fbdb6fbc4"
    sha256 cellar: :any_skip_relocation, monterey:       "a1d5d714ae46854a5a55ce30708deb110aad00df9a1a93bab0648b2fbdb6fbc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f266c6cc2694b12967424a549749762098a31a2247351106cf54ef0baf71d82"
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