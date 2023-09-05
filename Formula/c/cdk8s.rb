require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.73.0.tgz"
  sha256 "c07a14f327aad152c8d61ff377836f9eb51a3b994541dabd68e2bf50b6da0977"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d38d85e1e6020bd3a871fd975c2ec9f86d13232ec8570729ce8de607376363ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d38d85e1e6020bd3a871fd975c2ec9f86d13232ec8570729ce8de607376363ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d38d85e1e6020bd3a871fd975c2ec9f86d13232ec8570729ce8de607376363ae"
    sha256 cellar: :any_skip_relocation, ventura:        "ada535e394f6bec19f1c33d86e08b7635dce922be94ea2e0fc0081b2188a2b59"
    sha256 cellar: :any_skip_relocation, monterey:       "ada535e394f6bec19f1c33d86e08b7635dce922be94ea2e0fc0081b2188a2b59"
    sha256 cellar: :any_skip_relocation, big_sur:        "ada535e394f6bec19f1c33d86e08b7635dce922be94ea2e0fc0081b2188a2b59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d38d85e1e6020bd3a871fd975c2ec9f86d13232ec8570729ce8de607376363ae"
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