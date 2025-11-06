class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.173.0.tgz"
  sha256 "8077956d5cd3028e3a6304721bc50edd1729e4e7c47ace4a34f3fd23f9cb221f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a246a81b9a2f441692733eb1299ba55e8f16831c683f456f58c3cfcba5fc12fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e10c2673c93b7be9dc48e9074de73e0fa68f2b872612a529a14f1f2f61dc700"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e8c69f5e99fe2509563e45d6211ea693f80943cdd99065cd74bda95c291b335"
    sha256 cellar: :any_skip_relocation, sonoma:        "8906b3ff1534491f1acf6c9cc8302c46c1a5fa71681b6415a501d69a4a1e16ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd35a3b0827099714ff585a518806b9b8903f100bf59cd1a9377e3bccfc2764c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62dfbe1f7112abd8420c9b111b00eec5d7a7d87df0708613edee54f33e713ce7"
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