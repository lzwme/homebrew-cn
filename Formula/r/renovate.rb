class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.37.10.tgz"
  sha256 "a6d0de10f3a2dd1d5d3a35f17c9133931710a3467ec849d4cc5c8c2645bc16b6"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1de1261be4572af9ee2e356ccce1321bbcbd9785f255869fb6dc7cb08694cc31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed5352073acc7b2153b86f173549b32afc1606c2e88292463901130f432d839f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ad000a7ec6dd8bf5c00a700e6072e09b56675b223cd95e1aae8cfd6e6d04a25"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfbffdfdb3170531ac4605f89efc20e8c8a71c13822ecca04c6fcf10a14215c7"
    sha256 cellar: :any_skip_relocation, ventura:       "8cf106bef2b6d6300fd2779d0cd69fc27e923b6e0a5dfd95c155d9e0d30ae238"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e2ff1915e9a8bd59c30e603ef76fc5f2b8e7e2d14e03bb2178934aff8a787bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cb23dfefffc00939cb2638755ae7afa8e128cebe3e17b431451281726925c38"
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