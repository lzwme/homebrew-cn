class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.200.0.tgz"
  sha256 "050ccb701b060473b0a442dac6b63f6a68e61ec5699835237c741634fe6c0b05"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffe56e6027344b2d97d4d38d87f6c2d7ece7d4eb997ef82bf42e5b8f897e8e44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "120033f3eb67be5d825b90143e9161d5b1cda59e7f1374cbc12d104907973e31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "21e9641d1343ce3c3843a5da535551c46092b107d84d7bae1b64eecc91340f59"
    sha256 cellar: :any_skip_relocation, sonoma:        "82be21fcfd5719e860965c61284383f26e82ce5d4155c96324f2e8bc129c19cc"
    sha256 cellar: :any_skip_relocation, ventura:       "8ef613d42dac589cdf11bfc2faebf67403d4f9c1c4cca19f76c1e5b943d3b36a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b738067fdbdc4aceed54fdb385f8e807018cf03d243581d37b4e9b084c969b5f"
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