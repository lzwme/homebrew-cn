class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.21.0.tgz"
  sha256 "06a76328543507422ca83813bcf5c82f945ae4ac32591b763f0e4ba893e5d0e2"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f3d9b0777a3a60baf09efd23c517eac18a120c6daa18e52103976ed450fdb6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6a34e47f395a6da15a7acbcbfd4df9e17916b43d67728bf174df40c74e0778a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12f325d733c181448fad2c913aa50fbc93463afd624569ec1292944b9aaacf3e"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac4dd9fd4fa245f9cd0a40020de69a8c52e96d13d3a5545ed3f6fa4db73f61e0"
    sha256 cellar: :any_skip_relocation, ventura:        "40fb3157098b0c69d9b48117f6a9c9e4ec755e641e6be67d9a94c33cb40c4a0f"
    sha256 cellar: :any_skip_relocation, monterey:       "d2345d3f8742a6bc6107121132a6d0f0aa9eb28a73230b070d48908532a3a972"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2c76893d48bc3717e64f9587a8ebad69a117c96699b727233d730fe20881462"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}renovate 2>&1", 1)
  end
end