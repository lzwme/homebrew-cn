require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.39.tgz"
  sha256 "2543e52d469188e5ddcb14c836aca23b61cb5589153ec5e163c3766d126465d3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0cd6fd74e6b0769ad68d7bd3fb21da1012fddaa5668f4d27339b9499cf429ec3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0cd6fd74e6b0769ad68d7bd3fb21da1012fddaa5668f4d27339b9499cf429ec3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cd6fd74e6b0769ad68d7bd3fb21da1012fddaa5668f4d27339b9499cf429ec3"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed133581ea092c79238f0a93831cf88d248937e2881b69625c8a24ce40451880"
    sha256 cellar: :any_skip_relocation, ventura:        "ed133581ea092c79238f0a93831cf88d248937e2881b69625c8a24ce40451880"
    sha256 cellar: :any_skip_relocation, monterey:       "ed133581ea092c79238f0a93831cf88d248937e2881b69625c8a24ce40451880"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cd6fd74e6b0769ad68d7bd3fb21da1012fddaa5668f4d27339b9499cf429ec3"
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