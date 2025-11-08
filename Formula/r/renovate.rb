class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-42.1.0.tgz"
  sha256 "f44ddae78f98b07a87a5ab2c092147402404210f5d183dd5ecee3cb642fbeb6a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3cf6d204304b5f90ebce1eec352328c6ce681adef4f1e84c04b8944269d0b16b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d10fe94f1bbbd27932fbf3cf100c8592a5a0bed62dad631038cd9e9045513fb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a3ae0836f43079f9277cbc9b984ac32b67042a418c8a0c0be41c54a8e7ef12a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e11c91d60f8608b2dff7a398dae31beb970369ddd95d9303a141653e44637380"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92f356d0779907850653470d0f765bd4d5974987492e1a1158701ee21e9e67fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bb0f49a24930d667fb8d8c7054135d910d6ad0e5959c24dc1ed12b8bd93e495"
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