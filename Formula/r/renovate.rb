require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.387.0.tgz"
  sha256 "845aecb998063e727a6b9f88866b186cac308ceb61c3b6f6590ffea3a17f8361"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05c69817af0ac6ac11a42b9c9aa9474f0cbf1c08deb7324ca5b3e7591f324493"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50634ed7e69cb7f52ce9d8f81bb58e82d5e020750cab240bb2868fbfe85c1b97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a505a97f2716007836e10f2b78914108d43f228fb6975cc28d0f793108cf536"
    sha256                               sonoma:         "06bd433def6c171e89ae3c9a555ec19da05b56b5ae8daca8bb20b560ab482266"
    sha256                               ventura:        "dec6a07c9776fdfc06bbe01d6965faddff5fc68ba157314df26ad20c05c7e10b"
    sha256                               monterey:       "1350621b4518f0ec66d73919a9b5a87743d52bccfcc30f0195e8092461f9c8a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "493c12f853f05128f4089e93c472389ff39a64fef07a902673e29ca61a9b78a1"
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