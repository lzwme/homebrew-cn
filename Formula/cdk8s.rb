require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.94.tgz"
  sha256 "33d9c901dcb2bb67b96a702e3c4f0c0e4ec36f5828cde4498b42a4efbbb2f461"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db9fa0dd339ec3d77729f94ceded6e3fafb11e3fbbe67836209b280e2fa40e65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db9fa0dd339ec3d77729f94ceded6e3fafb11e3fbbe67836209b280e2fa40e65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db9fa0dd339ec3d77729f94ceded6e3fafb11e3fbbe67836209b280e2fa40e65"
    sha256 cellar: :any_skip_relocation, ventura:        "fbd33baf8afeaec1bcfd3efdb56b330b512a37e68f2c0cfa632c0d2867db670c"
    sha256 cellar: :any_skip_relocation, monterey:       "fbd33baf8afeaec1bcfd3efdb56b330b512a37e68f2c0cfa632c0d2867db670c"
    sha256 cellar: :any_skip_relocation, big_sur:        "fbd33baf8afeaec1bcfd3efdb56b330b512a37e68f2c0cfa632c0d2867db670c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db9fa0dd339ec3d77729f94ceded6e3fafb11e3fbbe67836209b280e2fa40e65"
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