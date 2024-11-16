class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.17.0.tgz"
  sha256 "65bab8afd8f1aca98f24ec4b6646bf7741c5d8ccd84c2baa6bd80df548c07cbf"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6ca0c577c4ba74fc4b81203407b32890b5b19b7f2a355db76b61aeadc165a77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a04ebca791feb10de6bf3318bec58a2c3a811e14be7e6791e03baf352d2f3af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9ebb34b87097ce453df5ce579029230b3d44f2e3425be78a9eca9e76247f224"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4a5090e6e5156e77a527c33e5f76f503245a44999efad0966c1469d84bb379e"
    sha256 cellar: :any_skip_relocation, ventura:       "4b525fb65b53fb756fef3ee96d56a33a26b639e0fb9ca0bc451bf6ab9391b5cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9c1d62502e573a05df13fd3b13f5dd5ccfd998bc34cadbe83fc564ef186181d"
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