require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.168.tgz"
  sha256 "044299b20d2e14bccdce2ffb23f81f72754e22f25388b2255e18f93292217c47"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e68d5afc1b959e5e1e6a0869cedfef06185bf90e0ebf70ff8c5a9675f6cf873b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e68d5afc1b959e5e1e6a0869cedfef06185bf90e0ebf70ff8c5a9675f6cf873b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e68d5afc1b959e5e1e6a0869cedfef06185bf90e0ebf70ff8c5a9675f6cf873b"
    sha256 cellar: :any_skip_relocation, sonoma:         "e968368909d4f2e6c7d460b18094472c265262d59c425f66665ba3e284b4183b"
    sha256 cellar: :any_skip_relocation, ventura:        "e968368909d4f2e6c7d460b18094472c265262d59c425f66665ba3e284b4183b"
    sha256 cellar: :any_skip_relocation, monterey:       "e968368909d4f2e6c7d460b18094472c265262d59c425f66665ba3e284b4183b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "148c5b258cfb314dc3aa9c931047ae6b044464a07cea1365c4ddda1f3ec66a78"
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