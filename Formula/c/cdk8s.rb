require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.60.0.tgz"
  sha256 "1618c6d115c8b388a89ea32398e02b2375f3bf2b926fd8aa8898bcb293285a96"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c26b5b6e775dec0f26d35713e57d2e113ce27009ec935c606088e7f891eca47b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c26b5b6e775dec0f26d35713e57d2e113ce27009ec935c606088e7f891eca47b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c26b5b6e775dec0f26d35713e57d2e113ce27009ec935c606088e7f891eca47b"
    sha256 cellar: :any_skip_relocation, ventura:        "5d944665f54017f1c4142721946b432b19c166487062ea3d40c4a8b4dfc24279"
    sha256 cellar: :any_skip_relocation, monterey:       "5d944665f54017f1c4142721946b432b19c166487062ea3d40c4a8b4dfc24279"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d944665f54017f1c4142721946b432b19c166487062ea3d40c4a8b4dfc24279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c26b5b6e775dec0f26d35713e57d2e113ce27009ec935c606088e7f891eca47b"
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