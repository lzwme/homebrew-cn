require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.83.0.tgz"
  sha256 "beb382b4d26c2b20bf9b2b0f990c6d4a2e3a089ee2b4ba7e6c456b9da00fb12c"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86d1e6f7bf9de95b1c73f27ae01d517659cf7c33b32b73f9396b029c5203c530"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86d1e6f7bf9de95b1c73f27ae01d517659cf7c33b32b73f9396b029c5203c530"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86d1e6f7bf9de95b1c73f27ae01d517659cf7c33b32b73f9396b029c5203c530"
    sha256 cellar: :any_skip_relocation, ventura:        "f31cd6490b5fa4f3f87c2d14eabfbd9df962b30d6712dc8a646b19e2ed5f762b"
    sha256 cellar: :any_skip_relocation, monterey:       "f31cd6490b5fa4f3f87c2d14eabfbd9df962b30d6712dc8a646b19e2ed5f762b"
    sha256 cellar: :any_skip_relocation, big_sur:        "f31cd6490b5fa4f3f87c2d14eabfbd9df962b30d6712dc8a646b19e2ed5f762b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86d1e6f7bf9de95b1c73f27ae01d517659cf7c33b32b73f9396b029c5203c530"
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