class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.60.0.tgz"
  sha256 "c4a95bdbbf033fdbaab8927b12746cdf6ea20615f45b261fd866680ad196d4b3"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0fcc3893e74c0e75b3e04bef01502811d7f8dea0051833f38a858cff330bed0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0c721086feaec44b3c4eb0434de260b5dbf05f86dcf9ec4266cb642ea911c30"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a0f846c76a00c259549c6bada1ce029bc44272be7f7b5971a4316e142e23a8d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "32076ace1001105905392f469403c0fbe96a01d956c47fc2243e66952227dc33"
    sha256 cellar: :any_skip_relocation, ventura:       "140a1e1fec00aef7ce232aadc2400fee9dfa40954fdf80d3c5059a37ca73a46c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b3bdaf8ddaf17f823d901a560d0b9c3cfd3d96b7605435858b2cf7da13ca77a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2646a223940f63d0ecd86c467ad09ef307bf830f1e55d56100505658d383c85b"
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