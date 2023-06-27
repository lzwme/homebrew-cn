require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.77.tgz"
  sha256 "133b3eb44fac338e1d2f64c26c8056418003b6ee611a9ce5dd15bd0d3e7c0469"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "706ddd5de02df5b1b35add61d6f6aec798c4140be1f7d590beed402af7d5afde"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "706ddd5de02df5b1b35add61d6f6aec798c4140be1f7d590beed402af7d5afde"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "706ddd5de02df5b1b35add61d6f6aec798c4140be1f7d590beed402af7d5afde"
    sha256 cellar: :any_skip_relocation, ventura:        "090704139ded9faba9ff3c5fb58312c7632d2434c0d855ce480bc0b73ce98654"
    sha256 cellar: :any_skip_relocation, monterey:       "090704139ded9faba9ff3c5fb58312c7632d2434c0d855ce480bc0b73ce98654"
    sha256 cellar: :any_skip_relocation, big_sur:        "090704139ded9faba9ff3c5fb58312c7632d2434c0d855ce480bc0b73ce98654"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "706ddd5de02df5b1b35add61d6f6aec798c4140be1f7d590beed402af7d5afde"
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