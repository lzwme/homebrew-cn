class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.31.0.tgz"
  sha256 "eea4609bd049f2e0ebdce0a728f3b1f39d7feb90f0fd9053e7999efa0a2ed72d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "628b70776e3c4c4585b1192e3c40018424a30e6304a15caaf66cff09e0b16584"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2edd509d0a30020983ac55d6fa4684a11b089b76ac2b460f24cb59901d046576"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b0b4d4a52e8736c64c80e3bfc78eff222a0f11eb5b3fd3a17faa51684c36067"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bec547aaa3b80ec8d264e542079f027a90878207b281351dbfbdfa33dcba8f7"
    sha256 cellar: :any_skip_relocation, ventura:       "e7123e48af652d51d3a76c8893e2ad00afc0f4c9bbcac6a1b230735e4dc44521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "caacdb4231fb0082bb3078ca358929f5d24c2685a65b29f54d47a0145189a269"
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