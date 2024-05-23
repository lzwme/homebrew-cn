require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.374.0.tgz"
  sha256 "dcd9d196674f71e33fe480400f5228ed366532e879ef72119e55f2922cdd86be"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2aa93d5cd9ca2c421392b1c5bf822d06c3e78997998106eefd9c525d6c31d31c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e52f6731b2bfa8e7544ff0cf542071bb3ba6f317d4b916bd2c4e33afdcc8481"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76de5030c5e4a6a7e6e37acc53a0f280839574f1a99ebe08752109fc5b6654e2"
    sha256                               sonoma:         "8e6e5b4d410d45b8d643937a0b8f6557408fd2d462f71ed7562d42e0f94927db"
    sha256                               ventura:        "de6e87ad8fac7ce32a9221509d89c528f1f16eaa1e25a813008cd1faf8f2df72"
    sha256                               monterey:       "cef73394987fccdbddf9170a644ccc0ccda9ff836bbd8ddce0e10c3e1289b6c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c5152b29f88c7ecd053f3c3294e91aedd524759769a177e948842fd317e8450"
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