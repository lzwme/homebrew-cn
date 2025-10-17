class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.151.0.tgz"
  sha256 "00cad95a03579609e21f4a28f93e0294945c712256b4232feea1ef4bdfba21e3"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ed88c2b336168c7f82d89826a481392ad99c6b609b5d5c219e0fdaa0dd81f39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81cffd523d21d32b2e32e43d47d38364e31ec38de163f12f3c438ff3e3ada9b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b381f4eb03853ba404eb8bd6a257c8a55e49ab01908016386b416f7b41f8d005"
    sha256 cellar: :any_skip_relocation, sonoma:        "658af7e2f793c61b9063099ea446df39ed26c958d180c7de7b7718f6a837f2b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9889dfd2745fd8e8151cf20d8d34980dd8549adec226f2551ca6cd7e894d6f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09ec3be72cab74902b7e43f6c545e92fe4e7bdfbd67744864dd203ca060528f9"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end