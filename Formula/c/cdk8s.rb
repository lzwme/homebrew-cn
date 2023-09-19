require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.93.0.tgz"
  sha256 "1b8c0c36ba0987884898a4d304b1c6d410943c374dde0511e4da2b98c3bc6563"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82b4f8426000e31c3f393e1b07e94e574a4336b07e2383e46393a45fac3f8705"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82b4f8426000e31c3f393e1b07e94e574a4336b07e2383e46393a45fac3f8705"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82b4f8426000e31c3f393e1b07e94e574a4336b07e2383e46393a45fac3f8705"
    sha256 cellar: :any_skip_relocation, ventura:        "74903a6b9d0d9554b308bba015e964b2a9b73a954db160ad3dee3ffdd2d65fb2"
    sha256 cellar: :any_skip_relocation, monterey:       "74903a6b9d0d9554b308bba015e964b2a9b73a954db160ad3dee3ffdd2d65fb2"
    sha256 cellar: :any_skip_relocation, big_sur:        "74903a6b9d0d9554b308bba015e964b2a9b73a954db160ad3dee3ffdd2d65fb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82b4f8426000e31c3f393e1b07e94e574a4336b07e2383e46393a45fac3f8705"
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