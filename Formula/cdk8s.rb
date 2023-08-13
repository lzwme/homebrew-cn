require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.34.0.tgz"
  sha256 "888d270845b6410a67b4550cf7ce2cc1d889e8131e9db02b7ed5826fed2d330b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2484b1614a29222a4fb8ab6878c31b9fd56583dd043a627cf331eede6ab13bb4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2484b1614a29222a4fb8ab6878c31b9fd56583dd043a627cf331eede6ab13bb4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2484b1614a29222a4fb8ab6878c31b9fd56583dd043a627cf331eede6ab13bb4"
    sha256 cellar: :any_skip_relocation, ventura:        "37c090458c520c8dda507ce9da6b047e521009aaf1b235f8e9b998dd64ff7bf3"
    sha256 cellar: :any_skip_relocation, monterey:       "37c090458c520c8dda507ce9da6b047e521009aaf1b235f8e9b998dd64ff7bf3"
    sha256 cellar: :any_skip_relocation, big_sur:        "37c090458c520c8dda507ce9da6b047e521009aaf1b235f8e9b998dd64ff7bf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2484b1614a29222a4fb8ab6878c31b9fd56583dd043a627cf331eede6ab13bb4"
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