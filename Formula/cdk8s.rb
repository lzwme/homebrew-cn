require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.37.tgz"
  sha256 "6786f344732113ae4feb96297cbff16df760448787c56cf551c781d3f442dfb2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8adc1c22c944452e7f1580b05d23c9be484cb567292a0da772ddeb31d5946722"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8adc1c22c944452e7f1580b05d23c9be484cb567292a0da772ddeb31d5946722"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8adc1c22c944452e7f1580b05d23c9be484cb567292a0da772ddeb31d5946722"
    sha256 cellar: :any_skip_relocation, ventura:        "89596acbfa5cd2085b94d84e3a507b7e2b5e85ca458327d15b1a4d7ebe3cf9ce"
    sha256 cellar: :any_skip_relocation, monterey:       "89596acbfa5cd2085b94d84e3a507b7e2b5e85ca458327d15b1a4d7ebe3cf9ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "89596acbfa5cd2085b94d84e3a507b7e2b5e85ca458327d15b1a4d7ebe3cf9ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8adc1c22c944452e7f1580b05d23c9be484cb567292a0da772ddeb31d5946722"
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