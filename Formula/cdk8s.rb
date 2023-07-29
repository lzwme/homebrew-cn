require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.11.0.tgz"
  sha256 "12e6f17fdc9f7217532743be453fa1f20727e11214fd330534f34eea414b1801"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a15a1734811b9aff77f6eb83f7bf2afe41d0b841968e5fd1953198a5229eedd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a15a1734811b9aff77f6eb83f7bf2afe41d0b841968e5fd1953198a5229eedd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a15a1734811b9aff77f6eb83f7bf2afe41d0b841968e5fd1953198a5229eedd"
    sha256 cellar: :any_skip_relocation, ventura:        "cbcf915d283d41be9a9af27a75f7a749160190a4edeb82b65d32d19fc9637293"
    sha256 cellar: :any_skip_relocation, monterey:       "cbcf915d283d41be9a9af27a75f7a749160190a4edeb82b65d32d19fc9637293"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbcf915d283d41be9a9af27a75f7a749160190a4edeb82b65d32d19fc9637293"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bc1856447481ee89c0e8de94571706270682348fc3c1a35075252a139c8b3f4"
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