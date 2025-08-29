class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.89.0.tgz"
  sha256 "3bfc5b21c0b0e2534733f606157c44ac5f864598c02f7543af89dd6f361eee22"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "261b5d5b2367cf748cfcc2557984a93c683230041dc06eea0d7027a0767f4373"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2258eeb961f4f08782d777ca9b2db1acf067b65140fd612cfe55f631226f3f41"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4fef0c91947d29e3de1192bd6d6479d827f482f18e9d57e86283d15e3c79e44f"
    sha256 cellar: :any_skip_relocation, sonoma:        "69ea369eefb77be7483048f720947d32502f0200a8167eda26d4a96bc535353d"
    sha256 cellar: :any_skip_relocation, ventura:       "b2ae18c733b50aae5d77c5b15179c8b52173bc7c44d38fc9708df6f067554264"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f511f2a0a6f4a07d8a7a1e2373a45d2ac159d22803ded440254215658b98304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b2517775292d81b78e924bd550ba3aeaade7a284c54bb82527b4e900b320b54"
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