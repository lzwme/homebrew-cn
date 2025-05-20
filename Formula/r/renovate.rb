class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-40.18.0.tgz"
  sha256 "164ec0357619e337dd47aa516231a5667fa3bdeb17d63cea109826d1d1713f9f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61a55d0d58a8bcb563a5d389fab927a64f17e95cc30544fcf4ed5cdfc6d28ebc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3124748eb10c0dbdc3d984f3d3cfb60df95ed459f7ec5e23e1644788eb3f4c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2dd0ac04431c37cffe2ba2a0311daa31b68661e50d2bbcc06de13eff295227eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf84ba7625f64af06c05638aea78ea872295d65772e230da1e7052c4c012e987"
    sha256 cellar: :any_skip_relocation, ventura:       "135095a5a4a8769b4a4d2075d693e35c9c525e700a9832d787c2fae196e1de61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b16f94b2e8212ea7d721e2486865ae5375c5f72d12e3a3ea5f58ce6d3e65eac2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdf0c84a79221f20b9208b71e187d7a9d1268ea479faa487befb32ca85ed685d"
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