class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.77.0.tgz"
  sha256 "ab78bb0fbc9a959d07efa7778f70af06aca5dbfd4ca8678fa8300d926eebe764"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5dc5917c6c108e99cb4713e2e8eae241b8298f67a752fc3251bfe5fd775a6ec9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b6bee9f09e2195e5f9494f028454f0a42c503fc9752477d7d74170bd846f417"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c5e6c24f6e539270d992ff091c8783a5e63553bc93dbd30df4a8936200994bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "085f92b4cb20332f6523652c93cf762f03fad5d87bd874ba50511fc0093a090d"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc03ab35789be254b22b67cf99811ce9c6ad039d0c3a2ba228f4053654e87977"
    sha256 cellar: :any_skip_relocation, ventura:        "75bd6e2b63c4f2c858c1827d4df4e7fb58c4ec883a151cdb2a2fb845833728cf"
    sha256 cellar: :any_skip_relocation, monterey:       "572920334f0ebe1af6f6d41b6a55241131f81376ed457007b5068f67d65b5192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33b64a756b4d10e90576a9aa5863d926c6b261ab58a7b25d5625b90c88061132"
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