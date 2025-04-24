class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.257.0.tgz"
  sha256 "2cf298817fde51ac1f7b3743ea33cebbf680e4b238f1a0ea5ff9aea4d245a221"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "449b00af4644db74886afdd86238fd528497838974dc12f56664f336505d4ec4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e7524ede7fe4d37b972af439a5498a1b54ab22609602cd91f5984488216a07e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ec73617c5d21b942121c22a5f1b76096ca392fa033b3d749d239f3d14e2f258"
    sha256 cellar: :any_skip_relocation, sonoma:        "b71d6a27ce4942031aa4667560423a3d6a8ed82311415e9ba9dd834349dd8801"
    sha256 cellar: :any_skip_relocation, ventura:       "52891f36b8f27f21c62df824f53520c6ebe33c07f565f7947ed99f0499473e4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c2db81d9f4297f66df019b9abf58137b8bce8d984b95cb9150acee233914462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a39366656ab1b9471d605c912e545f3f308246df5d4a8cead39ffc0b88bdcaa1"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end