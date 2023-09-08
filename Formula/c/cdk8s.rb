require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.78.0.tgz"
  sha256 "a6a5c44726ef5dd24c826835106c35ea1ef48131e8fe35a7ade753387783494b"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf2d4b7493503710ef3d8d8db400a782658f13a55d8d483f74971a60e21bd0b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf2d4b7493503710ef3d8d8db400a782658f13a55d8d483f74971a60e21bd0b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf2d4b7493503710ef3d8d8db400a782658f13a55d8d483f74971a60e21bd0b8"
    sha256 cellar: :any_skip_relocation, ventura:        "f2158b8b16644d1c0296d55bab7b2e8d83d4f901cd87b3d96cde8e84a69b1a6b"
    sha256 cellar: :any_skip_relocation, monterey:       "f2158b8b16644d1c0296d55bab7b2e8d83d4f901cd87b3d96cde8e84a69b1a6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2158b8b16644d1c0296d55bab7b2e8d83d4f901cd87b3d96cde8e84a69b1a6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf2d4b7493503710ef3d8d8db400a782658f13a55d8d483f74971a60e21bd0b8"
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