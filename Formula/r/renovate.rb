class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.95.0.tgz"
  sha256 "e1833489ff0ee9d10ecb486624d272fc6a2cca6f05322bb5b697b13c6da5c408"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce0778e54c920e21241397c16fbbcbf635f55be1d1a14e656bc10613dbc9e53e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81c2d615250e6474642ed3604f5a07cc6e9cc7db3a69c5d826173e9cefb3eb91"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48c120030b78228d3691fc8e7cfaf4a2b267ed631742f8065f589320572400c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d199da7f29c07ee7abf07c3e3a91f94ded91bad32f99f33f7a1867a2714457a"
    sha256 cellar: :any_skip_relocation, ventura:       "b971041af7d51f33d4515a275789239a2bcf00e82115ebc74fc1856d922be71f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ae5d8a924d3a45b163b80a9d916bb950ef2f1b6e31d5fcf24d965d0e88a346e"
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