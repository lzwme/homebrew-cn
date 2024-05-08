require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.349.0.tgz"
  sha256 "c9cb80bda96cf3ffa0208a53c907c82c0a4b5eaef702988a11499bdcc7d2c069"
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
    sha256                               arm64_sonoma:   "9f966534a5b678cb846cec3b9fdf39441ec63d623df63671506daf296c5e4a18"
    sha256                               arm64_ventura:  "0ea5eac55bbcba633241d3dd0397f9bfc8f2d557e02fb975b4abd140e2a333da"
    sha256                               arm64_monterey: "8d21cbd57a1efe244afa6eb140a2b358f1a491326bd222517bbdf94ed07f7cfd"
    sha256                               sonoma:         "2628a9e8812e6a37e6771516457efebfbdd2395f1c5b61ad02cea783669a6b1e"
    sha256                               ventura:        "25e229a6efbacf3b0c39de7b2a2d5f5a6ac0ef207219358936593d564b7b8952"
    sha256                               monterey:       "36f5ab1b97c269ef714ab9181836ece7aa2c7e50a8220c0a9f4bcb7d9043706f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb5296c1080089b71ccf83aee372de5f077ad7968dde12cbdf771a8028adeab1"
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