require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.63.tgz"
  sha256 "01568a346208d995da369d137fcb2fca81845d4ad980ada85a80ece1ee9698d3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1909d0bdb7961375d44a73d9610dcc7095055c9fc2814fd7efdd0d1b068760fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1909d0bdb7961375d44a73d9610dcc7095055c9fc2814fd7efdd0d1b068760fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1909d0bdb7961375d44a73d9610dcc7095055c9fc2814fd7efdd0d1b068760fe"
    sha256 cellar: :any_skip_relocation, ventura:        "580fa925369c457f9154e901ab5203ef7d1c2f4be8d89d1ee1d6cd0b870ad2a3"
    sha256 cellar: :any_skip_relocation, monterey:       "580fa925369c457f9154e901ab5203ef7d1c2f4be8d89d1ee1d6cd0b870ad2a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "580fa925369c457f9154e901ab5203ef7d1c2f4be8d89d1ee1d6cd0b870ad2a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1909d0bdb7961375d44a73d9610dcc7095055c9fc2814fd7efdd0d1b068760fe"
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