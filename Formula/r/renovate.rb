require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.330.0.tgz"
  sha256 "81899886c94509ff0cccaed573eef88fea3272a00cbf8409f2d8521e95af846c"
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
    sha256                               arm64_sonoma:   "41f035fff72259bbc71af2795c15f48d90d0cc9e514c80bcf1a0797746eff42b"
    sha256                               arm64_ventura:  "6aaaefd08a9035f789d5a4849038ff9c50577d7b51eb438a67edb61afe445a76"
    sha256                               arm64_monterey: "10b0862c35fd5deb648770d03e3bc688f1aeb5d06de1993225844e27aff3a87c"
    sha256                               sonoma:         "3d44cdc092571231d936dd82db995aceaa69d628c57b62b2ccee80eeb266ad51"
    sha256                               ventura:        "a030c3d4e3c2e70e3b8a8391e7123325c4da4a937673bd7b3e2e6f5005ea1e44"
    sha256                               monterey:       "e6534a059a1f81221fa05c8f9c7f6364073c43e080f5c23d3807f24ee8864c86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2f45942f28f866520f571abe249f94e65251f85dc28f116354a27b7fb7266b0"
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