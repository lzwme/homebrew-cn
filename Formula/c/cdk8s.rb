require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.79.0.tgz"
  sha256 "37d759816a819cbf65aa3ed8919f595f31ac846e0fb70b645ec952d638591871"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd29d6910fa196452e18ef052f6f809efb72ed4037a342323cc40cbc0cd7532f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd29d6910fa196452e18ef052f6f809efb72ed4037a342323cc40cbc0cd7532f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd29d6910fa196452e18ef052f6f809efb72ed4037a342323cc40cbc0cd7532f"
    sha256 cellar: :any_skip_relocation, ventura:        "f9357278b91233de69e09fc0812aea83efd0e66bf92b4e72e6efd597dcf7c787"
    sha256 cellar: :any_skip_relocation, monterey:       "f9357278b91233de69e09fc0812aea83efd0e66bf92b4e72e6efd597dcf7c787"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9357278b91233de69e09fc0812aea83efd0e66bf92b4e72e6efd597dcf7c787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd29d6910fa196452e18ef052f6f809efb72ed4037a342323cc40cbc0cd7532f"
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