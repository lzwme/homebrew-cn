class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.114.0.tgz"
  sha256 "f32e52bc473c11b0006a7937a4204b2f2927bd09c6a20036e9e6c5cd41df7b1e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c062e5ed88e0fb4f34711c321fc269e00908edf129d4fd5e47553294f222f9c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2225976c66edfdc88e1664704b653971efb734ad44670527bd17135b8ada405"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f328e941ee1947afa6e22f085844b626c98a052b08b88ba0163e20ef3e67d54f"
    sha256 cellar: :any_skip_relocation, sonoma:        "84e8275d0a295613eaaa1baa6fbf8f3922690c5fb50a8837cf0822166c1f3ac6"
    sha256 cellar: :any_skip_relocation, ventura:       "fbbe2d7f791071b4d8d4e4bcd6f86cbe6bc8fe576400c1ffb211b40629a3e7ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd1f7c149590fbd832956206f7557e7d3ad76a97a537daa27b78a7e0e369c1ea"
  end

  depends_on "node@20"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end