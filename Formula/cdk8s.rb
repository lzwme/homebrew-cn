require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.16.0.tgz"
  sha256 "74d717658aae3acccaf46b52998f116f4486b0cd3a6b5a64d29e10caa51c3c00"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "950959ee7d0e84ea6c85717c0ca7fef09ea5b8e89d6ed8bd6038467c674bf698"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "950959ee7d0e84ea6c85717c0ca7fef09ea5b8e89d6ed8bd6038467c674bf698"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "950959ee7d0e84ea6c85717c0ca7fef09ea5b8e89d6ed8bd6038467c674bf698"
    sha256 cellar: :any_skip_relocation, ventura:        "a75e58b2d49b5a1121d2b6e04285217cc9770828ddf900fdfd936c8a4f252204"
    sha256 cellar: :any_skip_relocation, monterey:       "a75e58b2d49b5a1121d2b6e04285217cc9770828ddf900fdfd936c8a4f252204"
    sha256 cellar: :any_skip_relocation, big_sur:        "a75e58b2d49b5a1121d2b6e04285217cc9770828ddf900fdfd936c8a4f252204"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef444e0fe0e0075cef2d1844abb4fe006e0cfaa02844141130c24538262aa6bf"
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