class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.262.0.tgz"
  sha256 "0a6d91f09e3202f04e4df3eafd0e04a034d76ca750995e2c52f4ba7c91c47576"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d89e6ccd7890e4c688a4869f0e16e25afe8e8cfec2ea1d5729e005227557173c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c61811760219347d10070847ebe74acdda8413d866a9a229b8e6110091bbafcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee85e9d773112fc27e7ab46875b3e38148b43e7f4386977201f7217357b77b96"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bb5a154bfd6dcb873da3697a66019e9a44428e278df032ac038bd3a721483ba"
    sha256 cellar: :any_skip_relocation, ventura:       "aeaafac893d0b2ad9e3add34923689add14d61839c373066545984ee9be82c57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6ef08e69ff2b7b3126908acbb9d4d18f54c3996694d62fdae6d27781b371022"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8931a93c1bc3add698db78a2b0b14989ce8af48af9071c3920ecec006b4b3fc0"
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