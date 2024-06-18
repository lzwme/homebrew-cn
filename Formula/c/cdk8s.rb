require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.147.tgz"
  sha256 "702d66981fd55f0a88968799e2dd4fb9fa909ebadb6ca66e29e05545c80239f6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e405f0a82c93bc34fe55b68cc0534c81d361e7c5e6a3e81fbd460a7074e0950"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e405f0a82c93bc34fe55b68cc0534c81d361e7c5e6a3e81fbd460a7074e0950"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e405f0a82c93bc34fe55b68cc0534c81d361e7c5e6a3e81fbd460a7074e0950"
    sha256 cellar: :any_skip_relocation, sonoma:         "51ddeec487c5102bc15b9e8b7264c2ec5ab8af9f3a148eba9fcdc2911850cc4a"
    sha256 cellar: :any_skip_relocation, ventura:        "51ddeec487c5102bc15b9e8b7264c2ec5ab8af9f3a148eba9fcdc2911850cc4a"
    sha256 cellar: :any_skip_relocation, monterey:       "51ddeec487c5102bc15b9e8b7264c2ec5ab8af9f3a148eba9fcdc2911850cc4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe5009e6457086f1e239d3ca9f6984b27c9b4925246fc5446c488b82ca1df7e3"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end