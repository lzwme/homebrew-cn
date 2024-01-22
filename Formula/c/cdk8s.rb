require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.33.tgz"
  sha256 "e13d30ad47ce06a1d4c5f857d7d71faf3797f140dccc6d242538cc342c0da941"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58ff5dc1f37730ae726b7bd4bb89ec1b098b4da019752c52494205335d7ff546"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58ff5dc1f37730ae726b7bd4bb89ec1b098b4da019752c52494205335d7ff546"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58ff5dc1f37730ae726b7bd4bb89ec1b098b4da019752c52494205335d7ff546"
    sha256 cellar: :any_skip_relocation, sonoma:         "50a68b2d7e61546fd5924db59932c38c66c0203dcf951936db21842d1ab31f4d"
    sha256 cellar: :any_skip_relocation, ventura:        "50a68b2d7e61546fd5924db59932c38c66c0203dcf951936db21842d1ab31f4d"
    sha256 cellar: :any_skip_relocation, monterey:       "50a68b2d7e61546fd5924db59932c38c66c0203dcf951936db21842d1ab31f4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58ff5dc1f37730ae726b7bd4bb89ec1b098b4da019752c52494205335d7ff546"
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