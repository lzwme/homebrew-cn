require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.91.0.tgz"
  sha256 "6bdb65c031ec315537a1a6fa71d2bd5d3b13c14d02a22756dad8df31d3f74f68"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96d87ca8c1a4c3c1c626544375e34d158f67614066cea2f2099053852ecaca41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96d87ca8c1a4c3c1c626544375e34d158f67614066cea2f2099053852ecaca41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96d87ca8c1a4c3c1c626544375e34d158f67614066cea2f2099053852ecaca41"
    sha256 cellar: :any_skip_relocation, ventura:        "216fc3178b3a230868d2ce9c1ea444702fa32cbd4b50a262818eb118ead50a32"
    sha256 cellar: :any_skip_relocation, monterey:       "216fc3178b3a230868d2ce9c1ea444702fa32cbd4b50a262818eb118ead50a32"
    sha256 cellar: :any_skip_relocation, big_sur:        "216fc3178b3a230868d2ce9c1ea444702fa32cbd4b50a262818eb118ead50a32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96d87ca8c1a4c3c1c626544375e34d158f67614066cea2f2099053852ecaca41"
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