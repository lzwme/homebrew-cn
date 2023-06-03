require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.50.tgz"
  sha256 "92685e2087f571c3fbb6b7b662b09acfec3ba701cf76acfee7a5dcd06cba8060"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0383e4acad70562a8ff16ae60f4d91a2586680770417a3f770aff702f15cefda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0383e4acad70562a8ff16ae60f4d91a2586680770417a3f770aff702f15cefda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0383e4acad70562a8ff16ae60f4d91a2586680770417a3f770aff702f15cefda"
    sha256 cellar: :any_skip_relocation, ventura:        "1faf29e38c69ad659036db0fe8f823e861e90ec47c90530e8e5a0357862dae9a"
    sha256 cellar: :any_skip_relocation, monterey:       "1faf29e38c69ad659036db0fe8f823e861e90ec47c90530e8e5a0357862dae9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "1faf29e38c69ad659036db0fe8f823e861e90ec47c90530e8e5a0357862dae9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0383e4acad70562a8ff16ae60f4d91a2586680770417a3f770aff702f15cefda"
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