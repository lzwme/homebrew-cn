class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.114.0.tgz"
  sha256 "09e142ba9197423a184e83a222a6235278fd55989d6f22fd00d9822b2d535019"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa2c768ebfa4d1717ed5f0add5b9340d89fe59277101f10bb933e291a68209ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a2b81af94cf691940486a3bdbec80faf207f51d4c56d676bdda8711f02d3c89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eafb6cc4dcc021f96a02b10118ff031e4453c53105a51aa350943ec3c308ae4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "81a38754e484f65e47e5a95ffc8b79fad915269a92d51cb3980e6e3f47af251d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4a2f9644f0205cdcbf81107b3ca1ff462f4a94cb59647f85537669d785b620b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3577d297be2b858a1a20d4d1f2af8f6c29abcae30dd3a5a73eb3d3b255b498cb"
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