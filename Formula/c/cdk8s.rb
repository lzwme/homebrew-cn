class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.67.tgz"
  sha256 "9f6cc47b8597636e0e4159ce87450437a02f64262b4fd23f9eb2820d4555b49e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "532e6adbddbb6f88d2f0647c65f85e93fd4dbea3d0286cbae36ec07fb07ebb46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "532e6adbddbb6f88d2f0647c65f85e93fd4dbea3d0286cbae36ec07fb07ebb46"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "532e6adbddbb6f88d2f0647c65f85e93fd4dbea3d0286cbae36ec07fb07ebb46"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7c0df011a61a990e334f9d68013764d2bd2e04de122bd3237f9cfc30cf2e92a"
    sha256 cellar: :any_skip_relocation, ventura:       "f7c0df011a61a990e334f9d68013764d2bd2e04de122bd3237f9cfc30cf2e92a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "532e6adbddbb6f88d2f0647c65f85e93fd4dbea3d0286cbae36ec07fb07ebb46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "532e6adbddbb6f88d2f0647c65f85e93fd4dbea3d0286cbae36ec07fb07ebb46"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end