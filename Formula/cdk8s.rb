require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.97.tgz"
  sha256 "8ea53de388ce501e883205177cd96198bfeda0c05305d39bf7cd52b4f76304c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6caa3d2f851275f4aff285baee94536277d3cd7ff71afdbbdfc8d21b4943591"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6caa3d2f851275f4aff285baee94536277d3cd7ff71afdbbdfc8d21b4943591"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6caa3d2f851275f4aff285baee94536277d3cd7ff71afdbbdfc8d21b4943591"
    sha256 cellar: :any_skip_relocation, ventura:        "8e005cdb511537d78b69300f3f8d780cbd9bccdbc87784e7cd5278ce0dd7209c"
    sha256 cellar: :any_skip_relocation, monterey:       "8e005cdb511537d78b69300f3f8d780cbd9bccdbc87784e7cd5278ce0dd7209c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e005cdb511537d78b69300f3f8d780cbd9bccdbc87784e7cd5278ce0dd7209c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6caa3d2f851275f4aff285baee94536277d3cd7ff71afdbbdfc8d21b4943591"
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