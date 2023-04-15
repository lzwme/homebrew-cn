require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.47.2.tgz"
  sha256 "4aef27a8b543937c003de3382b1fe918007ff24b770bdc6406df4c4def63e0bc"
  license "AGPL-3.0-only"

  bottle do
    sha256                               arm64_ventura:  "9b89e82f6e766c5e4e77c47abde5602b5e1b706152db2d5bd298f11279134b92"
    sha256                               arm64_monterey: "785326c6a017a4b7093c099cb2d98271d92d611cccb29cfcd2c764dfd4212c3a"
    sha256                               arm64_big_sur:  "8a8adf94cf50378f07b4a0fde48ddf134eb5d56cd07f76920413981256337bcc"
    sha256 cellar: :any_skip_relocation, ventura:        "53b1dd08baf3fd9b27d420e7bda852049d05335b981220bb693930818282411d"
    sha256 cellar: :any_skip_relocation, monterey:       "e61a3f73c1fee6b4b757d1bc36e8de60277259a0baf6028b8f2d93a9a1ccd6dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "3884ad9c973c79881162403e6023c5a010695debf2ee79a1ed2b03e0e68066b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f1070ba87f8f8b9bf91dfbc836eca75942e1f7d497dad4204152f9c21af1be2"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end