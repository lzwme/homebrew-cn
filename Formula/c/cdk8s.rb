require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.62.tgz"
  sha256 "05003657dfddb9181393e1277a57ff4ce2a9ee3f84c7af10a5d36ebb02f0a54d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9cefdf3d97b277ff8ff508b9d6c41217a6c984ec5175aaf3e2473285b01c1263"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9cefdf3d97b277ff8ff508b9d6c41217a6c984ec5175aaf3e2473285b01c1263"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cefdf3d97b277ff8ff508b9d6c41217a6c984ec5175aaf3e2473285b01c1263"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca65ff0e10fc2b1c43242892704f415c0d5985535ace80b1e15c38097ca0896d"
    sha256 cellar: :any_skip_relocation, ventura:        "ca65ff0e10fc2b1c43242892704f415c0d5985535ace80b1e15c38097ca0896d"
    sha256 cellar: :any_skip_relocation, monterey:       "ca65ff0e10fc2b1c43242892704f415c0d5985535ace80b1e15c38097ca0896d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cefdf3d97b277ff8ff508b9d6c41217a6c984ec5175aaf3e2473285b01c1263"
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