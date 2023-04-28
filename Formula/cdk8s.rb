require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.20.tgz"
  sha256 "ace07fbd975b05e6b99c3985b4a01b699c22dc1a79e4bf512b0c2b418867a3eb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "437ac6a929b2e0b49a05e98bcf68cca49ffca8446d7f6852e70953af603782a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "437ac6a929b2e0b49a05e98bcf68cca49ffca8446d7f6852e70953af603782a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "437ac6a929b2e0b49a05e98bcf68cca49ffca8446d7f6852e70953af603782a9"
    sha256 cellar: :any_skip_relocation, ventura:        "660f2973f630c21d70baf08afd2735519db927263f872401e9e803e4b225fcb4"
    sha256 cellar: :any_skip_relocation, monterey:       "660f2973f630c21d70baf08afd2735519db927263f872401e9e803e4b225fcb4"
    sha256 cellar: :any_skip_relocation, big_sur:        "660f2973f630c21d70baf08afd2735519db927263f872401e9e803e4b225fcb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "437ac6a929b2e0b49a05e98bcf68cca49ffca8446d7f6852e70953af603782a9"
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