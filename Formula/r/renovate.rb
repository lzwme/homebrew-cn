class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.168.0.tgz"
  sha256 "979903c86eaca01e8ceac84ba98339f18b18d0593d3a07a16f038509d5f4807a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bace7c79f09f064d3c930397fdf1419245682ae29de84cb1e9afb608d232b533"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "925999c2960a52968d9b5494f32b9839cb7eef79a15b53e8a292bd0973e3db95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af9c47ab1268c0b54e086ec676494232cfb31fb1f146683993f2318e0f0af00b"
    sha256 cellar: :any_skip_relocation, sonoma:        "783450953f375e768c6d3610f20521ef7d6992cbddc198df7a058defb63042bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "666279c9971e8a4370bed85cbc8fe9fb78c93693a3336a6ecac08b38936ff6e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8b0e10349ca040fd3cc1ef507f9ab4e9eee51fd6b0a1a9c428a45cbc84e00c3"
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