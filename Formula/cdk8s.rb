require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.45.tgz"
  sha256 "082bd588a23ecd3ab460f09396524bbe963cd4719e01296e99a7e0edeb0f3736"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee16e6935f85585bf0532da011593f47510e6a9b29ec041be257608424b34e97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee16e6935f85585bf0532da011593f47510e6a9b29ec041be257608424b34e97"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee16e6935f85585bf0532da011593f47510e6a9b29ec041be257608424b34e97"
    sha256 cellar: :any_skip_relocation, ventura:        "e9820818c5f471684ab1c953c0c22ea4262acaa9a40e968a84d59c1f0d40bdb4"
    sha256 cellar: :any_skip_relocation, monterey:       "e9820818c5f471684ab1c953c0c22ea4262acaa9a40e968a84d59c1f0d40bdb4"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9820818c5f471684ab1c953c0c22ea4262acaa9a40e968a84d59c1f0d40bdb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee16e6935f85585bf0532da011593f47510e6a9b29ec041be257608424b34e97"
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