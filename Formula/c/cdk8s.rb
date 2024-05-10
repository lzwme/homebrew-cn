require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.114.tgz"
  sha256 "ab53693dd5b7f53763acbeef2eaa430664a601d5078218afd1736befeacdffa6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0748166aafada6d1d5cd539833d429191dfdcac738d8c5ccf0fa1619f9fb4b16"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22b0d9ab32bf199e67d6472ad927c9a10a73d530993efef8754963b019e8bfe2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfbd6d0466d607ab11dd80e778bb49477103451d93306b4e7695c15b4f4fde85"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b20d377ea604a7bae893089bdc3a825c153665fd423f4f0b3d0084abcd6e8a8"
    sha256 cellar: :any_skip_relocation, ventura:        "a39d2a5afeb5a87cf7e0f85e23a026cbe723ebafe846ab40de0c0d558cf618cf"
    sha256 cellar: :any_skip_relocation, monterey:       "1a28c7f0019685a6b5210216b16405b99b6c567a2a32b09c33c52f6435599713"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc4e65a6f91351b3aad1760d911e9d208d9dfa04ce4db934db251369d80e6d2c"
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