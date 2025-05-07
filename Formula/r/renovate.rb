class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-40.7.0.tgz"
  sha256 "3c444ead6fa9d239b6a47da42eba9ebfba7d970dcfd76b48696fad4cabd2662a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c47a3c060ebdd963b3ad79939680811b3be2c11fb79baa80a6c5c41e4e6935b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a5234b66fa64f72c6b9e7afa933e3204b5cf6529a8c88def0319b7c593333a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3fafbceb0b6e22446a27d45711c4fc43cd037a3a745e87bd5210cbb3fec021e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "0262f392fb74987a723b4943099705647972295c4080854a54f1ed78430a40a0"
    sha256 cellar: :any_skip_relocation, ventura:       "02077df7718a2d677f64e2d8f9f8d7586a496ea52d7a18b5bf1649f131ea6fa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c56a99648fbdcefd36835c6cbd95f548b850abc0352ad75fb2c0b78acd50d4d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e81e566147bd3754e5993574aca22093da1b659bafcb35b65abe24bc468438e"
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