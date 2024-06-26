require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.417.0.tgz"
  sha256 "369bc658848cd3426d46d7d04ac3b70083830680e570aeb65e568f49925807cf"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1fbf4cf6007739c955883addf6e5e4abdc328b6f65210851a8c4ebdecb2d1cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "661a12dc7d3447c9c937079f7d8341452e247f372c6f2c465d0d535d9af3cc2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a41ff314d79e0184c50a6ba5246ecc0e716c272af6a842b4b87bb7ee3499309b"
    sha256 cellar: :any_skip_relocation, sonoma:         "125ec7fd677fa91ff371d05b476cf164f8754c92b258efcf69f1e41a91234ce2"
    sha256 cellar: :any_skip_relocation, ventura:        "bcf8537ab21a74dbf0dfe8006d7984a11730d7b0e3f4fb4edf010e8bfc251cb6"
    sha256 cellar: :any_skip_relocation, monterey:       "8e5755f34ddd33edb6e0d37d9516bf753405fa2c6df467ba62bf9f5415665bfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df3745202a146657188494800c58135590033f78f044bea6b140c8cddcf83eff"
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