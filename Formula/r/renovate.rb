class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.130.0.tgz"
  sha256 "805550d939eac711b7839c9f1c47f5aac378e0a55c73ed01f5f562d841532acb"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ba0108821d9769ae3ee2ca1f2533fec8ea9bd64f467825bc2b4d761bae2a53d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2aae825d34e83230b03d4cdf248ae9981e31f9ea530e35b412704aa0d980af03"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "efb09cdb8a7c536762eb8661e312f05b9415b6a8549118275c4cdf708734c338"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a5e641f8ab442683627310d133563ce3bdf99ad4ff37afb24c37eaa171f7f95"
    sha256 cellar: :any_skip_relocation, ventura:       "d662c24d9638f594219399e07b20003694f5082179ac361ba6a12b1f2e6423ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9aa4e8214d427166b34f1a775e0dfce1a8eb10f8ca3ce599a65a3c7b2580cee"
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