require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.72.0.tgz"
  sha256 "e11b4e56db917173efdc5707e7a12ebf7766e46875fd1f6a497c409cb459643e"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8cdd4130654cf23f62873b3a9f004d131d0be70e7e4dbdbe72d72450341224ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cdd4130654cf23f62873b3a9f004d131d0be70e7e4dbdbe72d72450341224ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8cdd4130654cf23f62873b3a9f004d131d0be70e7e4dbdbe72d72450341224ab"
    sha256 cellar: :any_skip_relocation, ventura:        "b5260c2854129a41d746f32e2b398aa6bfb16f853f78f44afd8d06a2073f9230"
    sha256 cellar: :any_skip_relocation, monterey:       "b5260c2854129a41d746f32e2b398aa6bfb16f853f78f44afd8d06a2073f9230"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5260c2854129a41d746f32e2b398aa6bfb16f853f78f44afd8d06a2073f9230"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cdd4130654cf23f62873b3a9f004d131d0be70e7e4dbdbe72d72450341224ab"
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