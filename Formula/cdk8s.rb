require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.25.tgz"
  sha256 "d7b66f6397373522a19f02d9457a900eb1e1c9e53f6f1c27a30df629dc4a4889"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "682edbab04d2bf04ebdab4b8864a0fa2416f0d65f296e3eec7ed5c8aba0bef22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "682edbab04d2bf04ebdab4b8864a0fa2416f0d65f296e3eec7ed5c8aba0bef22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "682edbab04d2bf04ebdab4b8864a0fa2416f0d65f296e3eec7ed5c8aba0bef22"
    sha256 cellar: :any_skip_relocation, ventura:        "560776e4345fdcfd826def4aad73cf31bb6f7e91feca50a8cd8d071c7dc1fff3"
    sha256 cellar: :any_skip_relocation, monterey:       "560776e4345fdcfd826def4aad73cf31bb6f7e91feca50a8cd8d071c7dc1fff3"
    sha256 cellar: :any_skip_relocation, big_sur:        "560776e4345fdcfd826def4aad73cf31bb6f7e91feca50a8cd8d071c7dc1fff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "682edbab04d2bf04ebdab4b8864a0fa2416f0d65f296e3eec7ed5c8aba0bef22"
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