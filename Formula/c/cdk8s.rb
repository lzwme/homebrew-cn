require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.111.0.tgz"
  sha256 "4b3afe85c68ad9afc6208ba11b4374a65b7609dccb5251ce1f40083890c7d053"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2e6d90014f502e3d2365a11fc9cf65b9ea84b3e60c21475c6d489be252edf89"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2e6d90014f502e3d2365a11fc9cf65b9ea84b3e60c21475c6d489be252edf89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2e6d90014f502e3d2365a11fc9cf65b9ea84b3e60c21475c6d489be252edf89"
    sha256 cellar: :any_skip_relocation, sonoma:         "57ff41f9fa37aa4af2e79cdb7bd48a44e4b1a24e3fc0724c3f3ee6fca2734b1f"
    sha256 cellar: :any_skip_relocation, ventura:        "57ff41f9fa37aa4af2e79cdb7bd48a44e4b1a24e3fc0724c3f3ee6fca2734b1f"
    sha256 cellar: :any_skip_relocation, monterey:       "57ff41f9fa37aa4af2e79cdb7bd48a44e4b1a24e3fc0724c3f3ee6fca2734b1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2e6d90014f502e3d2365a11fc9cf65b9ea84b3e60c21475c6d489be252edf89"
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