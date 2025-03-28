class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.219.0.tgz"
  sha256 "25a1473e0565898cd710478060157f68dbe656fcbfd47b5cd61204fec95427e5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae76dc018f3dc652fa03a9cc513fd827f1771ab76e760b5bab016d0ca11eff56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15455e1078eaaade2451d0864a95a107ba1fb47796dd5bce9687dd2527ff8c9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d7c2702ca954bc708674a919cbc8b5bfd9dcac76162fd662371ece8c8d240912"
    sha256 cellar: :any_skip_relocation, sonoma:        "f405547d603c4661fccd06795d31dc4f110c35124794b6a1b572d13b0ea1a2be"
    sha256 cellar: :any_skip_relocation, ventura:       "9fbd851a4d6822bf2073a5f1ad0bca6242371072326cb4b5a0d76dfbb43db3df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30b6cbfb4f36079539916365b5e49d68bf9d995ffb4a5b66af8dec3db7103974"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b06a82a28d028dc9b1c43ade74bb480461457a32c923be71b228ae714267109"
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