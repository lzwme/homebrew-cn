require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.193.0.tgz"
  sha256 "49b6d2a5170bde0532839df3be7d266793f0e464db95c5d12fa07bff066bbb8c"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0137ae0c0434bd39e012d96de98e634a233cf98fcba347c2a3ac491ffb07cfd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0137ae0c0434bd39e012d96de98e634a233cf98fcba347c2a3ac491ffb07cfd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0137ae0c0434bd39e012d96de98e634a233cf98fcba347c2a3ac491ffb07cfd8"
    sha256 cellar: :any_skip_relocation, sonoma:         "bfd29d21c6bcf07d614c5683975636f68a9b69d14b6c6e56347d3efd1e6300d3"
    sha256 cellar: :any_skip_relocation, ventura:        "bfd29d21c6bcf07d614c5683975636f68a9b69d14b6c6e56347d3efd1e6300d3"
    sha256 cellar: :any_skip_relocation, monterey:       "bfd29d21c6bcf07d614c5683975636f68a9b69d14b6c6e56347d3efd1e6300d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0137ae0c0434bd39e012d96de98e634a233cf98fcba347c2a3ac491ffb07cfd8"
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