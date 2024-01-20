require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.31.tgz"
  sha256 "bd0e0926214e117bb8a405944922218cbc522016d0effb7dcec871774bc89c02"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fda4068c6c0c888052bf616ed1864d31d2eb9465207662de2bdab25efdb601b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fda4068c6c0c888052bf616ed1864d31d2eb9465207662de2bdab25efdb601b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fda4068c6c0c888052bf616ed1864d31d2eb9465207662de2bdab25efdb601b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "16c18420f137353e55df193c3672c43904e6b5e63bd6dfaa855a36dd98b5975b"
    sha256 cellar: :any_skip_relocation, ventura:        "16c18420f137353e55df193c3672c43904e6b5e63bd6dfaa855a36dd98b5975b"
    sha256 cellar: :any_skip_relocation, monterey:       "16c18420f137353e55df193c3672c43904e6b5e63bd6dfaa855a36dd98b5975b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fda4068c6c0c888052bf616ed1864d31d2eb9465207662de2bdab25efdb601b1"
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