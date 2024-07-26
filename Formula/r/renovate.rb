require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.1.0.tgz"
  sha256 "c2ddc1b1cb41d040c07598647df62e14be9a390ac5df64066552560e19d5fae1"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "179a8bea4ecb25f438b48a4b1e3b23eff5a4228bca2cc933b127ade56a4c36c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6f9aaea9a5db789cb4f3200e40dd24ef0200525ce8322b772eb78d53dbcc631"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9a51586967c2d6872a13802402145c8b4f0b70c336bd2e536e5cd2f8b84b017"
    sha256 cellar: :any_skip_relocation, sonoma:         "b98eb9f835e3ba153c8cf38e6452bc6e99535f620dd34cda1c42e35fa6c1e2a5"
    sha256 cellar: :any_skip_relocation, ventura:        "d49b3183c5247d488826817e8e4668aa8b06d68d00002649fcb39f8893c90cb3"
    sha256 cellar: :any_skip_relocation, monterey:       "39d0cf40fd903d2a95f901a2558ebd6a1c26d3a6608e763a6cb85907179f8721"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e882ff38f79fa5dca1cae700465942752ba3e044e6bd33c6ef2fc7d714c6113"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}renovate 2>&1", 1)
  end
end