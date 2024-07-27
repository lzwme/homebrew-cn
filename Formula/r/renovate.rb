require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.3.0.tgz"
  sha256 "9ff225c508813848b9b4a4affca6e2224f897aef08e3743235916e9dab704c75"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https:github.comrenovatebotrenovatetags"
    regex(%r{href=["']?[^"' >]*?tagv?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e11171230899362b23c3bac803ba8deaa2170a03fb90e01f46ff9e7f4008d95e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a56037889e5f1e537612c2c7bb4c322b54eae6564ac94ac496a5cc9a0217b96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d4652818180bcf0226d76a86f1e314beea768a280e2e5be72d42a029528d57f"
    sha256 cellar: :any_skip_relocation, sonoma:         "e37d524fd5c47c64811bb3b137e7e6cca35da7536e2d57cd0f8020649ce6f374"
    sha256 cellar: :any_skip_relocation, ventura:        "ae3c8d1b5c46bacfc10efb90c9c12bea9bbaa97a0c29fc61674e7bbb55adf160"
    sha256 cellar: :any_skip_relocation, monterey:       "068c5b76586281e7f10a3495d94c337866c7b583907f8e4cf777a5df72ba1ec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9453850e5763d60352b024a0c5cad202998683061ce9f7fb6fc7b8e33d1e94ab"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}renovate 2>&1", 1)
  end
end