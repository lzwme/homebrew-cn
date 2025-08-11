class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.61.0.tgz"
  sha256 "f88c69a9462db8485484caf368ce85fa89d4ba7e814fbf9ac731f549a44c83a6"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53985cc0693ea004347e1b19aba22d7e0d4aefb4435978724cb5439edb734d3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1398205c5ce0bb3695709a6b910cb008bb93466f161d244efe88513f96e53521"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "757cc4c92755cb6118ac8c2349ecacfc3766e5605654571dc93246f3336ef39a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7238176c82d307e9e72d061ff1aaea3b1970696a399f6b796cb8cd22b334d58c"
    sha256 cellar: :any_skip_relocation, ventura:       "e8fd8f0967cce1fac63250b9b5d118d704f6115ac5c483943120da5c7dfd9a3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce7335b68d8fced3fb82e5e173a1b0c10cfa661386cca94518628b7101000daa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb74db8958521335c7e0f7edb792413dc401ec0e913a27462fda7721738f0f78"
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