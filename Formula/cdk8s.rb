require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.13.0.tgz"
  sha256 "dd42d22dedb20736e8814d9f3bcfee117312c826aed5a43f946015a9f43e396a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b525797d49e38bb12714970ca6efaecb2acdbe5ec92f1d57dea81fd1ea910d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b525797d49e38bb12714970ca6efaecb2acdbe5ec92f1d57dea81fd1ea910d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b525797d49e38bb12714970ca6efaecb2acdbe5ec92f1d57dea81fd1ea910d0"
    sha256 cellar: :any_skip_relocation, ventura:        "d9ebd5bec17ff6a3bac6f4280331f80ce02054875b70545690e003ece53a145e"
    sha256 cellar: :any_skip_relocation, monterey:       "d9ebd5bec17ff6a3bac6f4280331f80ce02054875b70545690e003ece53a145e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9ebd5bec17ff6a3bac6f4280331f80ce02054875b70545690e003ece53a145e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ef7392890486089732ec69df8ebde515c3e4a69736344d7b7a2f89912e8239f"
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