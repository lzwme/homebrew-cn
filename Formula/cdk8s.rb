require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.22.tgz"
  sha256 "7c7c26a9cab447429ca7d574e9546fe8630f4c267a9a99d064e157a1f6fe20e6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16f78b4b180386c7e74c2c88429ee1fe3c4f0c8266e1a4649b2329e9abee007e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16f78b4b180386c7e74c2c88429ee1fe3c4f0c8266e1a4649b2329e9abee007e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16f78b4b180386c7e74c2c88429ee1fe3c4f0c8266e1a4649b2329e9abee007e"
    sha256 cellar: :any_skip_relocation, ventura:        "6d1fb0be9750107dc2e85c4ba3a28c51d8f40850b9f697263a22cccbaf27d3db"
    sha256 cellar: :any_skip_relocation, monterey:       "6d1fb0be9750107dc2e85c4ba3a28c51d8f40850b9f697263a22cccbaf27d3db"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d1fb0be9750107dc2e85c4ba3a28c51d8f40850b9f697263a22cccbaf27d3db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16f78b4b180386c7e74c2c88429ee1fe3c4f0c8266e1a4649b2329e9abee007e"
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