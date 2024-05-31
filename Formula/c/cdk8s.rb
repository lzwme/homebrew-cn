require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.133.tgz"
  sha256 "02f754763af1ae1e284460bbbaedc56568c7c1dc54c3091324bad0dbc89b8d16"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db142e7c90e5cd5bd37ba11ca27bcd3a3362614965c96a7bf0b521e695ecb68b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db142e7c90e5cd5bd37ba11ca27bcd3a3362614965c96a7bf0b521e695ecb68b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db142e7c90e5cd5bd37ba11ca27bcd3a3362614965c96a7bf0b521e695ecb68b"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2a271a254173eefac0577bd7fa2b474fc6247b1bb4f04a28a8668be23177e66"
    sha256 cellar: :any_skip_relocation, ventura:        "d2a271a254173eefac0577bd7fa2b474fc6247b1bb4f04a28a8668be23177e66"
    sha256 cellar: :any_skip_relocation, monterey:       "d2a271a254173eefac0577bd7fa2b474fc6247b1bb4f04a28a8668be23177e66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e92cc4d7967cdc2a830d23b72569ae21b4ee6895c09adbea3103462759b4b136"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end