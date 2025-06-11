class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-40.49.0.tgz"
  sha256 "0c0c91b4e883ddc30d64330724d9b8a7fdd2fe998bab2fc09ce6d95d0af1a985"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "446896d83698659372951504c6a05a541f5fbec8436144e70aea48aa70e9def3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2676d4ca332448c2c8c10012294d9cdddf506453517518f16b72360781ce86df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f530da4985fddab4317e08265a1f708d43097b8b9d8fdcb40bbd02a40093089e"
    sha256 cellar: :any_skip_relocation, sonoma:        "08d3eb85ce043b017de402bde61eff529e76cdb63b389fa4dbec25e914058564"
    sha256 cellar: :any_skip_relocation, ventura:       "bc91b487a5d36c22eb78a72eceffee9c71869fc3f7d576cab8da520743e44719"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "178f78b7bb20548f84425aeb48e54a025cd5df55dcb20db5c2019c1053158594"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6755e611d0e6dcd0ec1cdee6763d52ad90433ac1b23bc6262e9f60b50d3d742"
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