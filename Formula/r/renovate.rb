class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.250.0.tgz"
  sha256 "2508870ffb56ce41f2c90f37698f35c2de42f3efddb43cf4de3e96e058dde1c7"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68cc8241dea14e99025660095ab946d960bc5c8c8468e010e964bfb4e1905114"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29ba59e4e8da217d156eebe43bfa51a74e08fcf9678e4e6cb7d67aaf419c6755"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bd8d62a2cdee24ea4e0b31543b7a7e1e24683c16fa5e7fe408386a19bd6605c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "12023edf76b1b0b70d17a724ded2ba4d1adb7ba2ee939a8ce8ee8187aa9288de"
    sha256 cellar: :any_skip_relocation, ventura:       "f85361bf704b4127cf41ebc2f21ca0c7accf3b7e623d7ae7cbbc9ffb68690f8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b73c4c9f702271848ae19aace6cfb7a6320092ebaf3ebae23e4ec8a5d5e7b3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b441e73494e15664982e2401c57d3135590df44780de9f73d4bea0f117e180fa"
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