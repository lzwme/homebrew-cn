require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.127.0.tgz"
  sha256 "32e028d2c50ac2dfc7aaec32092dd35796c17c252d25d9962c078a614591a404"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbb721c6c27b6628fb5fe811ee1bd037264c69d614cdf067e91cb39f8fc2e169"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbb721c6c27b6628fb5fe811ee1bd037264c69d614cdf067e91cb39f8fc2e169"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbb721c6c27b6628fb5fe811ee1bd037264c69d614cdf067e91cb39f8fc2e169"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7198051602de1d4815526b85c4e5282cc831da5e5013b1d5cc24b2056d000d7"
    sha256 cellar: :any_skip_relocation, ventura:        "e7198051602de1d4815526b85c4e5282cc831da5e5013b1d5cc24b2056d000d7"
    sha256 cellar: :any_skip_relocation, monterey:       "e7198051602de1d4815526b85c4e5282cc831da5e5013b1d5cc24b2056d000d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbb721c6c27b6628fb5fe811ee1bd037264c69d614cdf067e91cb39f8fc2e169"
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