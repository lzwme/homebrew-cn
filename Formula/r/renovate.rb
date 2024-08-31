class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.58.0.tgz"
  sha256 "2dedd3a8d5af56307522c5e0419da1fe18a46b83373ae2a17ff90bad69ed4d83"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ccddbd5c723593a47fba305e4a2f2d5300bdfb7d2e5272b801a51d808175d19e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a99df57301fe4cc0e495f232b4db200fbdd8434fcbd847aa065ea54439dab72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60f98c2d2f1efc17597d1c4e4471af657391706a7e69fc36b76dd0ac259646da"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce5b2ef3cf46003279a7d6315623152dfd929d042a078c1ae406e530180d6a18"
    sha256 cellar: :any_skip_relocation, ventura:        "08966a71fb5e90024992f7ef5b84d72c342b89a53ca7e9bdb6b66993cb40967e"
    sha256 cellar: :any_skip_relocation, monterey:       "60b46c1fa7f00ab45151d5f347721a9a9ab94158d45f6643a9f0fd92ac7ee22a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1c10d11e187976cbfde02cfb0df06eb6858605126caf323467b1c8621e66903"
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