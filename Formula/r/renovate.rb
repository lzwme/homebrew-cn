class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.2.0.tgz"
  sha256 "4b35a25f02c416c6358af34935bb3012cfe166b7d5188b9c477a932cd9357918"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23be941308f43335d7e9340c829fe9d51dc733977fef5f33825aa204b37e6835"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "773366f74929205d1b2a9d35b05811cd3b57aad0e45b494d66b731337ef85b4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df02e29ca6ed9b9b5641ccf2054473728bd8635fac5d21598bf4512e7b163eec"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf01b333684089b871adc8ff56df5092c570c7a13ffeb2a9c26b1c11dea0a501"
    sha256 cellar: :any_skip_relocation, ventura:       "63511bc726bbc219686392ca72ec899ccd16ad8ffa40dd5a9cfa4620cee5885f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1741e0c1fe0cd8326f8032826bb725daf1bed9eae3b185d22ecff8ec15c436f6"
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