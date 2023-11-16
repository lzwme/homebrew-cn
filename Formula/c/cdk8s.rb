require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.177.0.tgz"
  sha256 "785164d40978ad124dbb6d6e24a709024c72db09357d2642929427c1382b7a3e"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c410075d63ca9578a5db11dcba610fdd90c55d0def2b06ae6a2af9a66f14377d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c410075d63ca9578a5db11dcba610fdd90c55d0def2b06ae6a2af9a66f14377d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c410075d63ca9578a5db11dcba610fdd90c55d0def2b06ae6a2af9a66f14377d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9f2df4f3f8e8a7d06cd6cc77775ec6d41b0fcd010bbe5438b404cdae14989a6"
    sha256 cellar: :any_skip_relocation, ventura:        "a9f2df4f3f8e8a7d06cd6cc77775ec6d41b0fcd010bbe5438b404cdae14989a6"
    sha256 cellar: :any_skip_relocation, monterey:       "a9f2df4f3f8e8a7d06cd6cc77775ec6d41b0fcd010bbe5438b404cdae14989a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c410075d63ca9578a5db11dcba610fdd90c55d0def2b06ae6a2af9a66f14377d"
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