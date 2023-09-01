require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.68.1.tgz"
  sha256 "e2963e8dbab539cbb130ebcd34db736c8c3ea7b436bb6443fd1670f44e06845f"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f437ea3f23f748faee7138958bf2760efb4b465f275948952990c7fd2df7da5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f437ea3f23f748faee7138958bf2760efb4b465f275948952990c7fd2df7da5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f437ea3f23f748faee7138958bf2760efb4b465f275948952990c7fd2df7da5a"
    sha256 cellar: :any_skip_relocation, ventura:        "bfb806e147bef7b2524b90cde476f3210b8e50ec550db93ab4d8e434dd4d4b7b"
    sha256 cellar: :any_skip_relocation, monterey:       "bfb806e147bef7b2524b90cde476f3210b8e50ec550db93ab4d8e434dd4d4b7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfb806e147bef7b2524b90cde476f3210b8e50ec550db93ab4d8e434dd4d4b7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f437ea3f23f748faee7138958bf2760efb4b465f275948952990c7fd2df7da5a"
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