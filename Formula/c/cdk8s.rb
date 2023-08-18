require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.43.0.tgz"
  sha256 "9668e206b29896f21d8bc37aef280c7b7a3b8e8152fba663f9d722f531c0848e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "008d8a27b385a98e1b9b037adbbe1788b88f791a65a94fd41462d8e26eeb0453"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "008d8a27b385a98e1b9b037adbbe1788b88f791a65a94fd41462d8e26eeb0453"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "008d8a27b385a98e1b9b037adbbe1788b88f791a65a94fd41462d8e26eeb0453"
    sha256 cellar: :any_skip_relocation, ventura:        "3449dfd34c801c5c2ace96f1220e2215e73b264ed857690ca85c31d7c5602f2f"
    sha256 cellar: :any_skip_relocation, monterey:       "3449dfd34c801c5c2ace96f1220e2215e73b264ed857690ca85c31d7c5602f2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "3449dfd34c801c5c2ace96f1220e2215e73b264ed857690ca85c31d7c5602f2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "008d8a27b385a98e1b9b037adbbe1788b88f791a65a94fd41462d8e26eeb0453"
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